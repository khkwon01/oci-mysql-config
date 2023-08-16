variable "tenancy_ocid" {
  description = "Tenancy's OCID"
}

variable "user_ocid" {
  description = "User's OCID"
  default = ""
}

variable "compartment_ocid" {
  description = "Compartment's OCID where VCN will be created. "
  default = ""
}

variable "region" {
  description = "OCI Region"
}

variable "vcn" {
  description = "VCN Name"
  default     = "mysql_vcn"
}

variable "vcn_cidr" {
  description = "VCN's CIDR IP Block"
  default     = "10.5.0.0/16"
}

variable "admin_password" {
  description = "Password for the admin user for MySQL Database Service"
  default = "Welcome#1"
}

variable "admin_username" {
  description = "MySQL Database Service Username"
  default = "admin"
}

variable "mysql_shape" {
    default = "MySQL.VM.Standard.E3.2.32GB"
}


variable "mds_instance_name" {
  description = "Name of the MDS instance"
  default     = "MySQLInstance"
}


variable "deploy_mds_ha" {
  description = "Deploy High Availability for MDS"
  type        = bool
  default     = false
}
