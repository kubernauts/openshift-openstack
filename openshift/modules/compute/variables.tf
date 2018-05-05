variable "cluster_name" {}

variable "number_of_ops_masters" {}

variable "volume_size" {}

variable "number_of_etcd" {}

variable "number_of_ops_infra" {}

variable "number_of_ops_compute" {}

variable "number_of_bastions" {}

variable "public_key_path" {}

variable "image_id" {}

variable "image" {}

variable "ssh_user" {}

variable "flavor_ops_master" {}

variable "flavor_ops_infra" {}

variable "flavor_ops_compute" {}

variable "flavor_etcd" {}

variable "network_name" {}

variable "flavor_bastion" {}

variable "network_id" {}

variable "bastion_fips" {
  type = "list"
}
