output "ops_infra_fips" {
  value = ["${openstack_networking_floatingip_v2.ops_infra.*.address}"]
}

output "bastion_fips" {
  value = ["${openstack_networking_floatingip_v2.bastion.*.address}"]
}
