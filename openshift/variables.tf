variable "cluster_name" {
  default = "example"
}

variable "number_of_bastions" {
  default = 1
}

variable "number_of_ops_masters" {
  default = 2
}

variable "number_of_etcd" {
  default = 2
}

variable "number_of_ops_infra" {
  default = 1
}

variable "number_of_ops_compute" {
  default = 1
}

variable "volume_size" {
  description = "Size of the volume to be created in GB, this should not be less than 50GB"
  default     = 100
}

variable "public_key_path" {
  description = "The path of the ssh pub key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "image_id" {
  description = "ID of the image not the NAME"
  default     = "15feb201-0f7d-49f3-9c0f-d5953221b9a8"
}

variable "image" {
  description = "Name of the Image to be used"
  default     = "Centos 7"
}

variable "ssh_user" {
  description = "used to fill out tags for ansible inventory"
  default     = "ubuntu"
}

variable "flavor_bastion" {
  description = "Use 'nova flavor-list' command to see what your OpenStack instance uses for IDs"
  default     = 3
}

variable "flavor_ops_master" {
  description = "Use 'nova flavor-list' command to see what your OpenStack instance uses for IDs"
  default     = 3
}

variable "flavor_ops_infra" {
  description = "Use 'nova flavor-list' command to see what your OpenStack instance uses for IDs"
  default     = 3
}

variable "flavor_ops_compute" {
  description = "Use 'nova flavor-list' command to see what your OpenStack instance uses for IDs"
  default     = 3
}

variable "flavor_etcd" {
  description = "Use 'nova flavor-list' command to see what your OpenStack instance uses for IDs"
  default     = 3
}

variable "network_name" {
  description = "name of the internal network to use"
  default     = "internal"
}

variable "dns_nameservers" {
  description = "An array of DNS name server names used by hosts in this subnet."
  type        = "list"
  default     = []
}

variable "floatingip_pool" {
  description = "name of the floating ip pool to use"
  default     = "external"
}

variable "external_net" {
  description = "uuid of the external/public network"
}

variable "elb_api_fqdn" {
  description = "Domain name for the Openshift master api"
}

variable "openshift_deployment_type" {
  description = "The type of openshift deployment whether origin or enterprise"
}

variable "openshift_release" {
  description = "The openshift release version to be installed"
}

variable "openshift_master_default_subdomain" {
  description = "The FQDN for the router which the apps will be accessed through"
}
