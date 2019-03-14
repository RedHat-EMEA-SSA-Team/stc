#!/usr/bin/env bash

docker pull registry.access.redhat.com/rhel7/rhel
docker build \
    --build-arg RH_ORG_ID=$RHN_ORG_ID \
    --build-arg RH_ACTIVATIONKEY=$RHN_ACTIVATIONKEY \
    --build-arg RH_POOL_ID=$STC_SUBSCRIPTION_POOL_ID \
    -t quay.io/redhat/stc-openstack-provisioner:latest \
    .

docker tag quay.io/redhat/stc-openstack-provisioner:latest quay.io/redhat/stc-openstack-provisioner:$(docker run -ti quay.io/redhat/stc-openstack-provisioner:latest yum info openshift-ansible | grep Version | cut -f2 -d':'|tr -d ' '|tr -d '\r')

docker push quay.io/redhat/stc-openstack-provisioner