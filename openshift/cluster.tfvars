# your Kubernetes cluster name here
cluster_name = "kubernauts"

# Specify the type of Openshift deployment
openshift_deployment_type = "origin"

# SSH key to use for access to nodes
public_key_path = "/home/chris/.ssh/id_rsa.pub"

# image ID to use for bastion, masters, standalone etcd instances, and nodes
image_id = "15feb201-0f7d-49f3-9c0f-d5953221b9a8"

# image name to use for bastion, masters, standalone etcd instances, and nodes
image = "Centos 7"

# user on the node (ex. core on Container Linux, ubuntu on Ubuntu, etc.)
ssh_user = "centos"

# Openshift release to be installed
openshift_release = "3.9"

# FQDN for the master API
elb_api_fqdn = "shift.kubernauts.de"

# Openshift sub-domain i.e FQDN for the router through which the apps will be accessed
openshift_master_default_subdomain = "apps.kubernauts.de"

# 0|1 bastion nodes
number_of_bastions = 1

flavor_bastion = "8"

#Volume Size

volume_size = "40"

# standalone etcds
number_of_etcd = 1

flavor_etcd = "10"

# masters
number_of_ops_masters = 2

flavor_ops_master = "9"

# Infrastructure nodes (registry and router)

number_of_ops_infra = 1

flavor_ops_infra = "10"

# Compute nodes (run the actual application pods)

number_of_ops_compute = 1

flavor_ops_compute = "10"

# networking
network_name = "kubernauts_openshift_tk8"

external_net = "b1152444-f5ef-4c3d-a4b5-73324bfae4be"

floatingip_pool = "external"
