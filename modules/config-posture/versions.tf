terraform {
  required_version = ">= 1.0.0"
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = "~> 1.43"
    }
    oci = {
      source  = "oracle/oci"
    }
  }
}