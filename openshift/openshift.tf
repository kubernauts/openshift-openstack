provider "openstack" {
  cloud = "mycloud"
}

module "network" {
  source = "modules/network"

  external_net    = "${var.external_net}"
  network_name    = "${var.network_name}"
  cluster_name    = "${var.cluster_name}"
  dns_nameservers = "${var.dns_nameservers}"
}

module "ips" {
  source = "modules/ips"

  number_of_ops_masters = "${var.number_of_ops_masters}"
  number_of_ops_infra   = "${var.number_of_ops_infra}"
  floatingip_pool       = "${var.floatingip_pool}"
  number_of_bastions    = "${var.number_of_bastions}"
  external_net          = "${var.external_net}"
  network_name          = "${var.network_name}"
  router_id             = "${module.network.router_id}"
}

module "compute" {
  source = "modules/compute"

  cluster_name          = "${var.cluster_name}"
  number_of_ops_masters = "${var.number_of_ops_masters}"
  number_of_etcd        = "${var.number_of_etcd}"
  number_of_ops_infra   = "${var.number_of_ops_infra}"
  number_of_ops_compute = "${var.number_of_ops_compute}"
  number_of_bastions    = "${var.number_of_bastions}"
  public_key_path       = "${var.public_key_path}"
  image_id              = "${var.image_id}"
  image                 = "${var.image}"
  ssh_user              = "${var.ssh_user}"
  flavor_ops_master     = "${var.flavor_ops_master}"
  flavor_ops_infra      = "${var.flavor_ops_infra}"
  flavor_ops_compute    = "${var.flavor_ops_compute}"
  flavor_etcd           = "${var.flavor_etcd}"
  network_name          = "${var.network_name}"
  flavor_bastion        = "${var.flavor_bastion}"
  bastion_fips          = "${module.ips.bastion_fips}"
  volume_size           = "${var.volume_size}"

  network_id = "${module.network.router_id}"
}

module "lb" {
  source = "modules/lb"

  cluster_name              = "${var.cluster_name}"
  number_of_ops_masters     = "${var.number_of_ops_masters}"
  number_of_ops_infra       = "${var.number_of_ops_infra}"
  network_id                = "${module.network.network_id}"
  ops_master_priv_ips       = "${module.compute.ops_master_priv_ips}"
  ops_infra_priv_ips        = "${module.compute.ops_infra_priv_ips}"
  floatingip_pool           = "${var.floatingip_pool}"
  ops_master_security_group = "${module.compute.ops_master_security_group}"
  ops_infra_security_group  = "${module.compute.ops_infra_security_group}"
}

output "private_subnet_id" {
  value = "${module.network.network_id}"
}

output "floating_network_id" {
  value = "${var.external_net}"
}

output "router_id" {
  value = "${module.network.router_id}"
}

output "ops_master_lb_vip" {
  value = "${module.lb.ops_master_vip}"
}

output "ops_infra_lb_vip" {
  value = "${module.lb.ops_infra_vip}"
}

output "bastion_fips" {
  value = "${module.ips.bastion_fips}"
}

/*
* Create Kubespray Inventory File
*
*/
data "template_file" "inventory" {
  template = "${file("${path.module}/inventory.tpl")}"

  vars {
    #public_ip_address_bastion                = "${module.ips.bastion_fips}"
    connection_strings_master  = "${join("\n",formatlist("%s ansible_host=%s","${module.compute.ops_master_names}", "${module.compute.ops_master_priv_ips}"))}"
    connection_strings_node    = "${join("\n",formatlist("%s ansible_host=%s","${module.compute.ops_infra_names}", "${module.compute.ops_infra_priv_ips}"))}"
    connection_strings_compute = "${join("\n",formatlist("%s ansible_host=%s","${module.compute.ops_compute_names}", "${module.compute.ops_compute_priv_ips}"))}"
    connection_strings_etcd    = "${join("\n",formatlist("%s ansible_host=%s","${module.compute.ops_etcd_names}", "${module.compute.ops_etcd_priv_ips}"))}"
    list_master                = "${join("\n","${module.compute.ops_master_names}")}"

    #list_master_under_infra                  = "${join("\n",formatlist("%s openshift_schedulable=false", "${module.compute.ops_master_names}"))}"
    list_node                                = "${join("\n",formatlist("%s openshift_node_labels=\"{\"region\": \"infra\", \"zone\": \"default\"}\"", "${module.compute.ops_infra_names}"))}"
    list_compute                             = "${join("\n",formatlist("%s openshift_node_labels=\"{\"region\": \"primary\", \"zone\": \"east\"}\"", "${module.compute.ops_compute_names}"))}"
    list_etcd                                = "${join("\n","${module.compute.ops_etcd_names}")}"
    openshift_master_cluster_hostname        = "openshift_master_cluster_hostname=\"${var.elb_api_fqdn}\""
    openshift_master_cluster_public_hostname = "openshift_master_cluster_public_hostname=\"${var.elb_api_fqdn}\""
    ansible_ssh_user                         = "ansible_ssh_user=\"${var.ssh_user}\""
    openshift_deployment_type                = "openshift_deployment_type=\"${var.openshift_deployment_type}\""
    openshift_release                        = "${var.openshift_release}"
    openshift_master_default_subdomain       = "${var.openshift_master_default_subdomain}"
  }
}

resource "null_resource" "inventories" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > ./hosts.ini"
  }

  triggers {
    template = "${data.template_file.inventory.rendered}"
  }
}
