terraform {
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = "~> 1.42.0"
    }
  }
}

provider "sysdig" {
  sysdig_secure_url       = "https://secure-staging.sysdig.com"
  sysdig_secure_api_token = "<API_TOKEN>"
}

provider "oci" {
  tenancy_ocid     = "<TENANCY_OCID>"
  user_ocid        = "<USER_OCID>"
  fingerprint      = "<FINGERPRINT>"
  private_key_path = "<PRIVATE_KEY_PATH>"
  region           = "<REGION>"
}

module "onboarding" {
  source            = "../../../modules/onboarding"
  tenancy_ocid      = "<TENANCY_OCID>"
  is_organizational = true
}

module "config-posture" {
  source                   = "../../../modules/config-posture"
  sysdig_secure_account_id = module.onboarding.sysdig_secure_account_id
  tenancy_ocid             = module.onboarding.tenancy_ocid
  compartment_ocid         = module.onboarding.compartment_ocid
  is_organizational        = module.onboarding.is_organizational
}

resource "sysdig_secure_cloud_auth_account_feature" "config_posture" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_CONFIG_POSTURE"
  enabled    = true
  components = [module.config-posture.service_principal_component_id]
  depends_on = [module.config-posture]
}