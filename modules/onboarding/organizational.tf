#---------------------------------------------------------------------------------------------
# Call Sysdig Backend to create organization with foundational onboarding
# (ensure it is called after all above cloud resources are created)
#---------------------------------------------------------------------------------------------
resource "sysdig_secure_organization" "oracle_organization" {
  count                 = var.is_organizational ? 1 : 0
  management_account_id = sysdig_secure_cloud_auth_account.oracle_account.id
  depends_on = [
    oci_identity_policy.admit_onboarding_policy,
    sysdig_secure_cloud_auth_account.oracle_account
  ]
}