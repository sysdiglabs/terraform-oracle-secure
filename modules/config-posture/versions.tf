terraform {
  required_version = ">= 1.0.0"
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = ">= 3.11.2, < 4.0.0"
    }
    oci = {
      source = "oracle/oci"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}