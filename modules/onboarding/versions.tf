terraform {
  required_version = ">= 1.0.0"
  required_providers {
    sysdig = {
      source  = "local/sysdiglabs/sysdig"
      version = "~> 1.0.0" #TODO: change when provider is deployed - testing only
    }
    oci = {
      source  = "hashicorp/oci"
    }
  }
}