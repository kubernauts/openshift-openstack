output "ops_master_vip" {
  value = "${openstack_networking_floatingip_v2.master_ops_vip.address}"
}

output "ops_infra_vip" {
  value = "${openstack_networking_floatingip_v2.infra_ops_vip.address}"
}
