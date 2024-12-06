terraform {
  required_version = ">= 1.0.0"
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = "~> 1.40"
    }
    oci = {
      source  = "hashicorp/oci"
    }
  }
}