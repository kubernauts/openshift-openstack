variable "number_of_ops_masters" {}

variable "number_of_ops_infra" {}

variable "cluster_name" {}

variable "network_id" {}

variable "floatingip_pool" {}

variable "ops_master_priv_ips" {
  type = "list"
}

variable "ops_infra_priv_ips" {
  type = "list"
}

variable "ops_master_security_group" {}

variable "ops_infra_security_group" {}
