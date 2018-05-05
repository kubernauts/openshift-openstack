resource "null_resource" "dummy_dependency" {
  triggers {
    dependency_id = "${var.router_id}"
  }
}

resource "openstack_networking_floatingip_v2" "ops_infra" {
  count      = "${var.number_of_ops_infra}"
  pool       = "${var.floatingip_pool}"
  depends_on = ["null_resource.dummy_dependency"]
}

resource "openstack_networking_floatingip_v2" "bastion" {
  count      = "${var.number_of_bastions}"
  pool       = "${var.floatingip_pool}"
  depends_on = ["null_resource.dummy_dependency"]
}
