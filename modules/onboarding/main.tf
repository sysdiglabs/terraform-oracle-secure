#-----------------------------------------------------------------------------------------
# Fetch the data sources
#-----------------------------------------------------------------------------------------

# TODO: this needs to be updated once datasources are available
locals {
  sysdig_tenancy_ocid          = "ocid1.tenancy.oc1..aaaaaaaa26htcit3eytwicf3gavyqkgwr54cmdhuo3iim6i2vfetelnbayha"
  sysdig_onboarding_group_ocid = "ocid1.group.oc1..aaaaaaaanutpcrbz5yklzmkqlnsfc36eyaav5i7rfuxmdiyglgtgyj3jelmq"
  sysdig_onboarding_user_ocid  = "ocid1.user.oc1..aaaaaaaajdn4twgdk4cxcx3alzrn6apuims2dlr2iqaritg764xim6l5jqea"
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
    "Define tenancy sysdigTenancy as ${local.sysdig_tenancy_ocid}",
    "Define group onboardingGroup as ${local.sysdig_onboarding_group_ocid}",
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
  enabled       = true
  provider_tenant_id = var.tenancy_ocid // tenancy ocid
  provider_id = var.compartment_ocid == "" ? var.tenancy_ocid : var.compartment_ocid
  // or the root compartment if not specified
  provider_type = "PROVIDER_ORACLECLOUD"

  # TODO: add metadata back when https://github.com/draios/secure-backend/pull/38958 is merged

  component {
    type     = "COMPONENT_SERVICE_PRINCIPAL"
    instance = "secure-onboarding"
    version  = "v0.1.0"
    service_principal_metadata = jsonencode({
      oci = {
        api_key = {
          user_id = local.sysdig_onboarding_user_ocid
        }
      }
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