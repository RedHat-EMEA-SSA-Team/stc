Provisioning on OpenStack
=========

Provisionning of STC stack on top of OpenStack, inspired by https://github.com/ktenzer/openshift-on-openstack-123

Example Playbook
----------------


```
docker run -ti $(pwd):/work:z quay.io/redhat/stc-openstack-provisioner

export OS_USERNAME=admin
export OS_PASSWORD=xxxx
export OS_AUTH_URL=xxxx
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_IDENTITY_API_VERSION=3

export STC_RHN_PASSWORD=xxxx
export STC_RHN_USERNAME=xxx
export STC_SUBSCRIPTION_POOL_ID=xx
export STC_REGISTRY_TOKEN_USER=xxx
export STC_REGISTRY_TOKEN=xxxx
export STC_FLAVOR=mini  # Only supported flavor at the moment is mini

cd /work
./playbooks/bb00-openstack_provisioning.yml
```


License
-------

Apache 2.0

Author Information
------------------

Robert Bohne 
robert.bohne@redhat.com