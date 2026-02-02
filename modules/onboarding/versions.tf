terraform {
  required_version = ">= 1.0.0"
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = "~> 3.3"
    }
    oci = {
      source = "oracle/oci"
    }
  }
}