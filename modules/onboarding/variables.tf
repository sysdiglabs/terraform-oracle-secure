variable "is_organizational" {
  type        = bool
  default     = false
  description = "(Optional) True/False whether secure-for-cloud should be deployed in an organizational setup"
}

variable "region" {
  type        = string
  default     = "us-sanjose-1"
  description = "(Optional) Default region for resource creation"
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

