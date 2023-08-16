data "oci_core_images" "images_for_shape" {
    compartment_id = var.compartment_ocid
    operating_system = var.operator_os
    operating_system_version = var.operator_os_version
    shape = var.operator_shape
    sort_by = "TIMECREATED"
    sort_order = "DESC"
}

resource "oci_core_instance" "operator" {

  availability_domain = data.template_file.ad_names.*.rendered[0]
  compartment_id      = var.compartment_ocid
  display_name        = var.operator_name
  shape               = var.operator_shape

  shape_config {
    memory_in_gbs = var.operator_shape_memory
    ocpus = var.operator_shape_ocpus
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.operator-subnet-regional.id
  }

  metadata = {
    ssh_authorized_keys = var.operator_ssh_public_key
  }

  source_details {
    source_id   = data.oci_core_images.images_for_shape.images[0].id
    source_type = "image"
  }
}
