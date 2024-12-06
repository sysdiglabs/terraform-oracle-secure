#-----------------------------------------------------------------------------------------
# Fetch the data sources
#-----------------------------------------------------------------------------------------

data "sysdig_secure_trusted_oracle_app" "onboarding" {
  name = "onboarding"
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

resource "oci_identity_policy" "admit_onboarding_policy" {
  name           = "AdmitSysdigSecureTenantOnboarding-${random_id.suffix.hex}"
  description    = "Onboarding policy to allow inspect compartments in tenant/compartment"
  compartment_id = var.tenancy_ocid
  statements = [
    "Define tenancy sysdigTenancy as ${data.sysdig_secure_trusted_oracle_app.onboarding.tenancy_ocid}",
    "Define group onboardingGroup as ${data.sysdig_secure_trusted_oracle_app.onboarding.group_ocid}",
    "Admit group onboardingGroup of tenancy sysdigTenancy to inspect tenancies in tenancy",
      var.compartment_ocid != "" ?
      "Admit group onboardingGroup of tenancy sysdigTenancy to inspect compartments in compartment ${data.oci_identity_compartment.compartment[0].name}"
      :
      "Admit group onboardingGroup of tenancy sysdigTenancy to inspect compartments in tenancy",
  ]
}


#---------------------------------------------------------------------------------------------
# Call Sysdig Backend to create account with foundational onboarding
# (ensure it is called after all above cloud resources are created using explicit depends_on)
#---------------------------------------------------------------------------------------------
resource "sysdig_secure_cloud_auth_account" "oracle_account" {
  enabled            = true
  provider_tenant_id = var.tenancy_ocid // tenancy ocid
  // when compartmentID is not specified, default to the rootCompartmentOCID which is the same value as tenancyOCID
  provider_id        = var.compartment_ocid == "" ? var.tenancy_ocid : var.compartment_ocid
  provider_type      = "PROVIDER_ORACLECLOUD"

  component {
    type     = "COMPONENT_SERVICE_PRINCIPAL"
    instance = "secure-onboarding"
    version  = "v0.1.0"
    service_principal_metadata = jsonencode({
      oci = {
        api_key = {
          user_id = data.sysdig_secure_trusted_oracle_app.onboarding.user_ocid
        }
      }
#       policy = {
#         policy_id = oci_identity_policy.admit_onboarding_policy.id
#       }
    })
  }

  lifecycle {
    # features and components are managed outside this module
    ignore_changes = [
      component,
      feature
    ]
  }
  depends_on = [
    oci_identity_policy.admit_onboarding_policy
  ]
}