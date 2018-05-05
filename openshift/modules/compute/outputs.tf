output "ops_master_priv_ips" {
  value = ["${openstack_compute_instance_v2.ops_master.*.network.0.fixed_ip_v4}"]
}

output "ops_infra_priv_ips" {
  value = ["${openstack_compute_instance_v2.ops_infra.*.network.0.fixed_ip_v4}"]
}

output "ops_compute_priv_ips" {
  value = ["${openstack_compute_instance_v2.ops_compute.*.network.0.fixed_ip_v4}"]
}

output "ops_etcd_priv_ips" {
  value = ["${openstack_compute_instance_v2.ops_etcd.*.network.0.fixed_ip_v4}"]
}

output "ops_master_names" {
  value = ["${openstack_compute_instance_v2.ops_master.*.name}"]
}

output "ops_infra_names" {
  value = ["${openstack_compute_instance_v2.ops_infra.*.name}"]
}

output "ops_compute_names" {
  value = ["${openstack_compute_instance_v2.ops_compute.*.name}"]
}

output "ops_etcd_names" {
  value = ["${openstack_compute_instance_v2.ops_etcd.*.name}"]
}

output "ops_master_security_group" {
  value = "${openstack_compute_secgroup_v2.ops_master.id}"
}

output "ops_infra_security_group" {
  value = "${openstack_compute_secgroup_v2.ops_infra.id}"
}
