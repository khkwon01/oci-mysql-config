resource "oci_mysql_mysql_db_system" "MDSinstance" {
    admin_password = var.admin_password
    admin_username = var.admin_username
    availability_domain = var.availability_domain
    compartment_id = var.compartment_ocid
    configuration_id = oci_mysql_mysql_configuration.mds_mysql_configuration.id
    shape_name = var.mysql_shape
    subnet_id = var.subnet_id
    data_storage_size_in_gb = var.mysql_data_storage_in_gb
    display_name = var.display_name

    is_highly_available = var.deploy_ha
}


data "oci_mysql_mysql_configurations" "mds_mysql_configurations" {
  compartment_id = var.compartment_ocid

  #Optional
  state        = "ACTIVE"
  shape_name   = var.mysql_shape
}


resource "oci_mysql_mysql_configuration" "mds_mysql_configuration" {
	#Required
	compartment_id = var.compartment_ocid
        shape_name   = var.mysql_shape

	#Optional
	description = "MDS configuration created by terraform"
	display_name = "MDS terraform configuration"
	parent_configuration_id = data.oci_mysql_mysql_configurations.mds_mysql_configurations.configurations[0].id
	variables {

		#Optional
		#max_connections = "501"
                binlog_expire_logs_seconds = "86400"
	}
}
