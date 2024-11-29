#-----------------------------------------------------------------------------------------
# Fetch the data sources
#-----------------------------------------------------------------------------------------

# TODO: this needs to be updated once datasources are available
locals {
  sysdig_tenancy_ocid          = "ocid1.tenancy.oc1..aaaaaaaa26htcit3eytwicf3gavyqkgwr54cmdhuo3iim6i2vfetelnbayha"
  sysdig_config_posture_group_ocid = "ocid1.group.oc1..aaaaaaaanutpcrbz5yklzmkqlnsfc36eyaav5i7rfuxmdiyglgtgyj3jelmq"
  sysdig_config_posture_user_ocid = "ocid1.user.oc1..aaaaaaaajdn4twgdk4cxcx3alzrn6apuims2dlr2iqaritg764xim6l5jqea"
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
    "Define tenancy sysdigTenancy as ${local.sysdig_tenancy_ocid}",
    "Define group configPostureGroup as ${local.sysdig_config_posture_group_ocid}",
      var.compartment_ocid != "" ?
      "Admit group configPostureGroup of tenancy sysdigTenancy to read all-resources in compartment ${data.oci_identity_compartment.compartment[0].name}" :
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
        user_id = local.sysdig_config_posture_user_ocid
      }
    }
  })
  depends_on = [
    oci_identity_policy.admit_cspm_policy
  ]
}
