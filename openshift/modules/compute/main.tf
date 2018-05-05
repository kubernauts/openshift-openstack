resource "openstack_compute_keypair_v2" "ops" {
  name       = "openshift-${var.cluster_name}"
  public_key = "${chomp(file(var.public_key_path))}"
}

resource "openstack_compute_secgroup_v2" "ops_master" {
  name        = "${var.cluster_name}-ops-master"
  description = "${var.cluster_name} - openshift Master"

  rule {
    ip_protocol = "tcp"
    from_port   = "8443"
    to_port     = "8443"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "ops_infra" {
  name        = "${var.cluster_name}-ops-infra"
  description = "${var.cluster_name} - openshift infra"

  rule {
    ip_protocol = "tcp"
    from_port   = "80"
    to_port     = "80"
    cidr        = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "tcp"
    from_port   = "443"
    to_port     = "443"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "bastion" {
  name        = "${var.cluster_name}-bastion"
  description = "${var.cluster_name} - Bastion Server"

  rule {
    ip_protocol = "tcp"
    from_port   = "22"
    to_port     = "22"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "ops" {
  name        = "${var.cluster_name}-ops"
  description = "${var.cluster_name} - openshift"

  rule {
    ip_protocol = "icmp"
    from_port   = "-1"
    to_port     = "-1"
    cidr        = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "tcp"
    from_port   = "1"
    to_port     = "65535"
    self        = true
  }

  rule {
    ip_protocol = "udp"
    from_port   = "1"
    to_port     = "65535"
    self        = true
  }

  rule {
    ip_protocol = "icmp"
    from_port   = "-1"
    to_port     = "-1"
    self        = true
  }
}

resource "openstack_compute_instance_v2" "bastion" {
  name       = "${var.cluster_name}-bastion-${count.index+1}"
  count      = "${var.number_of_bastions}"
  image_name = "${var.image}"
  flavor_id  = "${var.flavor_bastion}"
  key_pair   = "${openstack_compute_keypair_v2.ops.name}"

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_compute_secgroup_v2.ops.name}",
    "${openstack_compute_secgroup_v2.bastion.name}",
    "default",
  ]

  metadata = {
    ssh_user   = "${var.ssh_user}"
    tk8_groups = "bastion"
    depends_on = "${var.network_id}"
  }
}

resource "openstack_compute_instance_v2" "ops_master" {
  name      = "${var.cluster_name}-ops-master-${count.index+1}"
  count     = "${var.number_of_ops_masters}"
  flavor_id = "${var.flavor_ops_master}"
  key_pair  = "${openstack_compute_keypair_v2.ops.name}"

  block_device {
    uuid                  = "${var.image_id}"
    source_type           = "image"
    volume_size           = "${var.volume_size}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_compute_secgroup_v2.ops_master.name}",
    "${openstack_compute_secgroup_v2.bastion.name}",
    "${openstack_compute_secgroup_v2.ops.name}",
    "default",
  ]

  metadata = {
    ssh_user   = "${var.ssh_user}"
    tk8_groups = "etcd,kube-master,ops-cluster,vault"
    depends_on = "${var.network_id}"
  }
}

resource "openstack_compute_instance_v2" "ops_etcd" {
  name      = "${var.cluster_name}-ops-etcd-${count.index+1}"
  count     = "${var.number_of_etcd}"
  flavor_id = "${var.flavor_etcd}"
  key_pair  = "${openstack_compute_keypair_v2.ops.name}"

  block_device {
    uuid                  = "${var.image_id}"
    source_type           = "image"
    volume_size           = "${var.volume_size}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_compute_secgroup_v2.ops.name}"]

  metadata = {
    ssh_user   = "${var.ssh_user}"
    tk8_groups = "etcd,vault,no-floating"
    depends_on = "${var.network_id}"
  }
}

resource "openstack_compute_instance_v2" "ops_infra" {
  name      = "${var.cluster_name}-ops-infra-${count.index+1}"
  count     = "${var.number_of_ops_infra}"
  flavor_id = "${var.flavor_ops_infra}"
  key_pair  = "${openstack_compute_keypair_v2.ops.name}"

  block_device {
    uuid                  = "${var.image_id}"
    source_type           = "image"
    volume_size           = "${var.volume_size}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_compute_secgroup_v2.ops.name}",
    "${openstack_compute_secgroup_v2.bastion.name}",
    "${openstack_compute_secgroup_v2.ops_infra.name}",
    "default",
  ]

  metadata = {
    ssh_user   = "${var.ssh_user}"
    tk8_groups = "kube-infra,ops-cluster"
    depends_on = "${var.network_id}"
  }
}

resource "openstack_compute_instance_v2" "ops_compute" {
  name      = "${var.cluster_name}-ops-compute-${count.index+1}"
  count     = "${var.number_of_ops_compute}"
  flavor_id = "${var.flavor_ops_compute}"
  key_pair  = "${openstack_compute_keypair_v2.ops.name}"

  block_device {
    uuid                  = "${var.image_id}"
    source_type           = "image"
    volume_size           = "${var.volume_size}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_compute_secgroup_v2.ops.name}",
    "${openstack_compute_secgroup_v2.bastion.name}",
    "${openstack_compute_secgroup_v2.ops_infra.name}",
    "default",
  ]

  metadata = {
    ssh_user   = "${var.ssh_user}"
    tk8_groups = "kube-compute,ops-cluster"
    depends_on = "${var.network_id}"
  }
}

resource "openstack_compute_floatingip_associate_v2" "bastion" {
  count       = "${var.number_of_bastions}"
  floating_ip = "${var.bastion_fips[count.index]}"
  instance_id = "${element(openstack_compute_instance_v2.bastion.*.id, count.index)}"
}
