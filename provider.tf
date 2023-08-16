provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region = var.region
  user_ocid = var.user_ocid
}


terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
    }
  }
}
