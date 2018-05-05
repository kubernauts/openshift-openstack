resource "openstack_lb_loadbalancer_v2" "master_ops" {
  name           = "${var.cluster_name}-master-lb"
  admin_state_up = "true"
  vip_subnet_id  = "${var.network_id}"

  security_group_ids = [
    "${var.ops_master_security_group}",
  ]
}

resource "openstack_networking_floatingip_v2" "master_ops_vip" {
  pool    = "${var.floatingip_pool}"
  port_id = "${openstack_lb_loadbalancer_v2.master_ops.vip_port_id}"

  depends_on = [
    "openstack_lb_loadbalancer_v2.master_ops",
  ]
}

resource "openstack_lb_listener_v2" "master_ops" {
  protocol        = "HTTPS"
  protocol_port   = 8443
  loadbalancer_id = "${openstack_lb_loadbalancer_v2.master_ops.id}"
}

resource "openstack_lb_pool_v2" "master_ops" {
  protocol    = "HTTPS"
  lb_method   = "ROUND_ROBIN"
  listener_id = "${openstack_lb_listener_v2.master_ops.id}"
}

resource "openstack_lb_member_v2" "master_ops" {
  name          = "${var.cluster_name}-master-ops-lb-member"
  count         = "${var.number_of_ops_masters}"
  pool_id       = "${openstack_lb_pool_v2.master_ops.id}"
  subnet_id     = "${var.network_id}"
  address       = "${element(var.ops_master_priv_ips, count.index)}"
  protocol_port = 8443

  depends_on = [
    "openstack_lb_loadbalancer_v2.master_ops",
  ]
}

resource "openstack_lb_monitor_v2" "master_ops" {
  pool_id        = "${openstack_lb_pool_v2.master_ops.id}"
  type           = "HTTPS"
  delay          = 20
  timeout        = 10
  max_retries    = 5
  url_path       = "/"
  expected_codes = 200
}

resource "openstack_lb_loadbalancer_v2" "infra_ops" {
  name           = "${var.cluster_name}-infra-lb"
  admin_state_up = "true"
  vip_subnet_id  = "${var.network_id}"

  security_group_ids = [
    "${var.ops_infra_security_group}",
  ]
}

resource "openstack_networking_floatingip_v2" "infra_ops_vip" {
  pool    = "${var.floatingip_pool}"
  port_id = "${openstack_lb_loadbalancer_v2.infra_ops.vip_port_id}"

  depends_on = [
    "openstack_lb_loadbalancer_v2.infra_ops",
  ]
}

resource "openstack_lb_listener_v2" "infra_ops_443" {
  protocol        = "TCP"
  protocol_port   = 443
  loadbalancer_id = "${openstack_lb_loadbalancer_v2.infra_ops.id}"
}

resource "openstack_lb_pool_v2" "infra_ops_443" {
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = "${openstack_lb_listener_v2.infra_ops_443.id}"
}

resource "openstack_lb_member_v2" "infra_ops_443" {
  name          = "${var.cluster_name}-infra-ops-lb-member_443"
  count         = "${var.number_of_ops_infra}"
  pool_id       = "${openstack_lb_pool_v2.infra_ops_443.id}"
  subnet_id     = "${var.network_id}"
  address       = "${element(var.ops_infra_priv_ips, count.index)}"
  protocol_port = 443

  depends_on = [
    "openstack_lb_loadbalancer_v2.infra_ops",
  ]
}

resource "openstack_lb_monitor_v2" "infra_ops_443" {
  pool_id        = "${openstack_lb_pool_v2.infra_ops_443.id}"
  type           = "HTTPS"
  delay          = 20
  timeout        = 10
  max_retries    = 5
  url_path       = "/"
  expected_codes = 200
}
