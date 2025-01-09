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

variable "region" {
  type = string
  description = "(Required) Customer home region"
}

