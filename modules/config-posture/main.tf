#-----------------------------------------------------------------------------------------
# Fetch the data sources
#-----------------------------------------------------------------------------------------

data "sysdig_secure_trusted_oracle_app" "config_posture" {
  name = "config_posture"
}

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
# Admit policy to allow Sysdig Tenant to read resources
#-----------------------------------------------------------------------------------------

resource "oci_identity_policy" "admit_cspm_policy" {
  name           = "AdmitSysdigSecureTenantConfigPosture-${random_id.suffix.hex}"
  description    = "Config Posture policy to allow read all resources in tenant/compartment"
  compartment_id = var.tenancy_ocid
  statements = [
    "Define tenancy sysdigTenancy as ${data.sysdig_secure_trusted_oracle_app.config_posture.tenancy_ocid}",
    "Define group configPostureGroup as ${data.sysdig_secure_trusted_oracle_app.config_posture.group_ocid}",
      var.compartment_ocid != "" ?
      "Admit group configPostureGroup of tenancy sysdigTenancy to read all-resources in compartment ${data.oci_identity_compartment.compartment[0].name}"
      :
      "Admit group configPostureGroup of tenancy sysdigTenancy to read all-resources in tenancy",
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
        user_id = data.sysdig_secure_trusted_oracle_app.config_posture.user_ocid
      }
#       policy = {
#         policy_id = oci_identity_policy.admit_onboarding_policy.id
#       }
    }
  })
  depends_on = [
    oci_identity_policy.admit_cspm_policy
  ]
}
