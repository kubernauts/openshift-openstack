[all]
${connection_strings_master}
${connection_strings_node}
${connection_strings_compute}
${connection_strings_etcd}

[OSEv3:children]
masters
nodes
etcd

# Set variables common for all OSEv3 hosts
[OSEv3:vars]
${ansible_ssh_user}
${openshift_deployment_type}
enable_excluders=false
ansible_become=true
openshift_release=${openshift_release}
openshift_disable_check=docker_storage
openshift_repos_enable_testing=true

#Disable disk and memory checks
openshift_disable_check=disk_availability,memory_availability

# Uncomment the following to enable htpasswd authentication; defaults to
# DenyAllPasswordIdentityProvider.
openshift_master_identity_providers=[{"name": "htpasswd_auth", "login": "true", "challenge": "true", "kind": "HTPasswdPasswordIdentityProvider", "filename": "/etc/origin/master/htpasswd"}]
# Native high availability cluster method with optional load balancer.
# If no lb group is defined installer assumes that a load balancer has
# been preconfigured. For installation the value of
# openshift_master_cluster_hostname must resolve to the load balancer
# or to one or all of the masters defined in the inventory if no load
# balancer is present.
openshift_master_cluster_method=native
${openshift_master_cluster_hostname}
${openshift_master_cluster_public_hostname}
openshift_master_default_subdomain="${openshift_master_default_subdomain}"


# host group for masters
[masters]
${list_master}


# host group for nodes, includes region info
[nodes]
${list_master}
${list_node}
${list_compute}


# host group for etcd
[etcd]
${list_etcd}
