#-----------------------------------------------------------------------------------------
# Fetch the data sources
#-----------------------------------------------------------------------------------------

// compartment data to populate policies if onboarding a compartment
data "oci_identity_compartment" "compartment" {
  count = var.compartment_ocid != "" ? 1 : 0
  id    = var.compartment_ocid
}


// random suffix for policy name
resource "random_id" "suffix" {
  byte_length = 3
}

#-----------------------------------------------------------------------------------------
# Create Group, User and Group Membership
#-----------------------------------------------------------------------------------------
resource "oci_identity_group" "cspm_group" {
  name           = "SysdigSecureConfigPostureGroup-${random_id.suffix.hex}"
  description    = "Sysdig Secure CSPM Group"
  compartment_id = var.tenancy_ocid
}

resource "oci_identity_user" "cspm_user" {
  name           = "SysdigSecureConfigPostureUser-${random_id.suffix.hex}"
  description    = "Sysdig Secure CSPM User"
  compartment_id = var.tenancy_ocid
  email          = var.email
}

resource "oci_identity_user_group_membership" "cspm_user_to_group" {
  user_id  = oci_identity_user.cspm_user.id
  group_id = oci_identity_group.cspm_group.id
}

#-----------------------------------------------------------------------------------------
# Create RSA key for user
#-----------------------------------------------------------------------------------------

resource "tls_private_key" "rsa_key" {
  count     = var.private_key_file_path == "" && var.public_key_file_path == "" ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "oci_identity_api_key" "cspm_user_api_key" {
  user_id   = oci_identity_user.cspm_user.id
  key_value = (var.public_key_file_path == "" && var.private_key_file_path == "") ? tls_private_key.rsa_key[0].public_key_pem : file(var.public_key_file_path)
}

#-----------------------------------------------------------------------------------------
# Allow policy to allow user to read resources
#-----------------------------------------------------------------------------------------

resource "oci_identity_policy" "allow_cspm_policy" {
  name           = "AllowSysdigSecureTenantConfigPosture-${random_id.suffix.hex}"
  description    = "Config Posture allow policy to read all resources in tenant"
  compartment_id = var.tenancy_ocid
  statements = [
    "Allow group ${oci_identity_group.cspm_group.name} to read all-resources in tenancy",
  ]
}

#--------------------------------------------------------------------------------------------------------------
# Call Sysdig Backend to add the service-principal integration for Config Posture to the Sysdig Cloud Account
#--------------------------------------------------------------------------------------------------------------
resource "sysdig_secure_cloud_auth_account_component" "oracle_service_principal" {
  account_id = var.sysdig_secure_account_id
  type       = "COMPONENT_SERVICE_PRINCIPAL"
  instance   = "secure-posture"
  version    = "v0.1.0"
  service_principal_metadata = jsonencode({
    oci = {
      api_key = {
        user_id     = oci_identity_user.cspm_user.id
        region      = var.region
        fingerprint = oci_identity_api_key.cspm_user_api_key.fingerprint
        private_key = (var.public_key_file_path == "" && var.private_key_file_path == "") ? base64encode(tls_private_key.rsa_key[0].private_key_pem) : base64encode(file(var.private_key_file_path))
      }
      policy = {
        policy_id = oci_identity_policy.allow_cspm_policy.id
      }
    }
  })
  depends_on = [
    oci_identity_policy.allow_cspm_policy
  ]
}