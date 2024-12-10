variable "is_organizational" {
  type        = bool
  default     = false
  description = "(Optional) True/False whether secure-for-cloud should be deployed in an organizational setup"
}

variable "tenancy_ocid" {
  type        = string
  description = "(Required) Customer tenant OCID"
}

variable "compartment_ocid" {
  type        = string
  default     = ""
  description = "(Optional) Customer compartment OCID"
}

variable "sysdig_secure_account_id" {
  type        = string
  description = "(Required) ID of the Sysdig Cloud Account to enable Config Posture for (in case of organization, ID of the Sysdig management account)"
}