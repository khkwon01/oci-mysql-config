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
  default     = "mysql-mds-vcn"
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


#operator
variable operator_shape { default = "VM.Standard.E4.Flex" }
variable operator_shape_ocpus { default = 1 }
variable operator_shape_memory { default = 8 }
variable operator_ssh_public_key { default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvRZ6JUfI6qGFL5Y3Ql2/9Awr3stdOTUTK2dDbvppG0f8gSACQHK6qdJkuQMESRdaTlxhBAxBxBB46C6d9v2bYSroyNhGPf3Nk2vqaV5Sg75krHqnT4UTnRaTxGj3xj6xtpBsVFABIAK7fNwrrWvza+8MLyX83rwUGlm8CPoI5a32+EUuNEiOzWnPRCtuh+rnpozyRgEQyVD/r0Y/rQIwQVrvdTn2XziIkJ8gxGn39FtswUArwuo/iJ306WXaMxYzTpVVhiw+dzKPOoCz4R0D9PsuxL3EtZeXSi8B8di2Og5caURu4E5j3lsBvUkD/mUD3JTZap9KGImVjfM7B3/zn"}
variable operator_ssh_private_key_path { default = "./keys/id_rsa"}
variable operator_os { default = "Oracle Linux" }
variable operator_os_version { default = "8" }
variable operator_name { default = "MDS-Client" }
