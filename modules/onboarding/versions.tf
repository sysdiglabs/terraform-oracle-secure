terraform {
  required_version = ">= 1.0.0"
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = "~> 1.42"
    }
    oci = {
      source  = "oracle/oci"
    }
  }
}