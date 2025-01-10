output "tenancy_ocid" {
  value       = var.tenancy_ocid
  description = "Customer tenancy OCID"
}

output "compartment_ocid" {
  value       = var.compartment_ocid
  description = "Customer compartment OCID"
}

output "sysdig_secure_account_id" {
  value       = sysdig_secure_cloud_auth_account.oracle_account.id
  description = "ID of the Sysdig Cloud Account created"
}

output "is_organizational" {
  value       = var.is_organizational
  description = "Boolean value to indicate if secure-for-cloud is deployed to an entire Oracle organization or not"
}

output "region" {
  value = local.home_region[0]
  description = "Customer home region"
}
