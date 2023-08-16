data "oci_identity_availability_domains" "ad" {
  compartment_id = var.tenancy_ocid
}

data "template_file" "ad_names" {
  count    = length(data.oci_identity_availability_domains.ad.availability_domains)
  template = lookup(data.oci_identity_availability_domains.ad.availability_domains[count.index], "name")
}

data "oci_mysql_mysql_configurations" "shape" {
    compartment_id = var.compartment_ocid
    type = ["DEFAULT"]
    shape_name = var.mysql_shape
}

resource oci_core_vcn mds-vcn {
  cidr_block     = "10.5.0.0/16"
  compartment_id = var.compartment_ocid
  defined_tags = {
  }
  display_name = var.vcn
  dns_label    = "ocidevcluster"
  freeform_tags = {
  }
}

resource oci_core_internet_gateway mds-igw {
  compartment_id = var.compartment_ocid
  defined_tags = {
  }
  display_name = "mds-igw"
  enabled      = "true"
  freeform_tags = {
  }
  vcn_id = oci_core_vcn.mds-vcn.id
}

resource oci_core_subnet mds-subnet-regional {
  
  cidr_block     = "10.5.20.0/24"
  compartment_id = var.compartment_ocid
  defined_tags = {
  }
  dhcp_options_id = oci_core_vcn.mds-vcn.default_dhcp_options_id
  display_name    = "mds-subnet-regional"
  dns_label       = "mdssubnet"
  freeform_tags = {
  }
  
  prohibit_public_ip_on_vnic = "true"
  route_table_id             = oci_core_vcn.mds-vcn.default_route_table_id
  security_list_ids = [
    oci_core_security_list.mds-seclist.id,
  ]
  vcn_id = oci_core_vcn.mds-vcn.id
}

resource oci_core_subnet operator-subnet-regional {
  
  cidr_block     = "10.5.10.0/24"
  compartment_id = var.compartment_ocid
  defined_tags = {
  }
  dhcp_options_id = oci_core_vcn.mds-vcn.default_dhcp_options_id
  display_name    = "operator-subnet-regional"
  dns_label       = "operatorsubnet"
  freeform_tags = {
  }
  
  prohibit_public_ip_on_vnic = "false"
  route_table_id             = oci_core_vcn.mds-vcn.default_route_table_id
  security_list_ids = [
    oci_core_security_list.operator-seclist.id,
  ]
  vcn_id = oci_core_vcn.mds-vcn.id
}

resource oci_core_default_dhcp_options Default-DHCP-Options-for-mds-vcn {
  defined_tags = {
  }
  display_name = "Default DHCP Options for mds-vcn"
  freeform_tags = {
  }
  manage_default_resource_id = oci_core_vcn.mds-vcn.default_dhcp_options_id
  options {
    custom_dns_servers = [
    ]
    
    server_type = "VcnLocalPlusInternet"
    type        = "DomainNameServer"
  }
  options {
    
    search_domain_names = [
      "ocidevcluster.oraclevcn.com",
    ]
    
    type = "SearchDomain"
  }
}
  
resource oci_core_default_route_table mds-routetable {
  defined_tags = {
  }
  display_name = "mds-routetable"
  freeform_tags = {
  }
  manage_default_resource_id = oci_core_vcn.mds-vcn.default_route_table_id
  route_rules {
    
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.mds-igw.id
  }
}

resource oci_core_security_list mds-seclist {
  compartment_id = var.compartment_ocid
  defined_tags = {
  }
  display_name = "mds-seclist"

  egress_security_rules {
    
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    
    protocol  = "all"
    stateless = "false"
    
  }
  freeform_tags = {
  }
  ingress_security_rules {
    
    protocol    = "all"
    source      = "10.5.10.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = "true"
    
  }
  ingress_security_rules {
    
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    
  }
  vcn_id = oci_core_vcn.mds-vcn.id
}

resource oci_core_security_list operator-seclist {
  compartment_id = var.compartment_ocid
  defined_tags = {
  }
  display_name = "operator-seclist"

  egress_security_rules {
    
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    
    protocol  = "all"
    stateless = "false"
    
  }
  freeform_tags = {
  }
  ingress_security_rules {
    
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    
  }
  ingress_security_rules {
    
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "22"
      min = "22"
    }    
  }
  ingress_security_rules {
    
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "80"
      min = "80" 
    }
  }  
  ingress_security_rules {
    
    protocol    = "all"
    source      = "10.5.20.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = "true"
    
  }
  vcn_id = oci_core_vcn.mds-vcn.id
}

module "mds-instance" {
  source         = "./modules/mds-instance"
  admin_password = var.admin_password
  admin_username = var.admin_username
  availability_domain = data.template_file.ad_names.*.rendered[0]
  configuration_id = data.oci_mysql_mysql_configurations.shape.configurations[0].id
  compartment_ocid = var.compartment_ocid
  subnet_id = oci_core_subnet.mds-subnet-regional.id
  display_name = var.mds_instance_name
  deploy_ha = var.deploy_mds_ha
  mysql_shape = var.mysql_shape
}
