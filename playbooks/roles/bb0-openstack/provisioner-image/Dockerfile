#FROM  registry.access.redhat.com/rhel7/rhel
FROM registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7
ARG RH_ORG_ID
ARG RH_ACTIVATIONKEY
ARG RH_POOL_ID   


RUN subscription-manager register --org=$RH_ORG_ID --activationkey=$RH_ACTIVATIONKEY --name=temp-containerbuild-$(date +"%s")  && \
# ToDo: subscription-manager attach --pool=... FAILED with:
#       This unit has already had the subscription matching pool ID "8a85f99c65c8c91b0166c4c531662125" attached.
    subscription-manager attach --pool=$RH_POOL_ID ;\
    subscription-manager repos --disable=* && \
    subscription-manager repos --enable=rhel-7-server-rpms \
        --enable=rhel-7-server-extras-rpms \
        --enable=rhel-7-server-ose-3.11-rpms \
        --enable=rhel-7-server-ansible-2.6-rpms \
        --enable=rhel-7-server-openstack-14-rpms \
#        --enable=rhel-7-server-openstack-14-devtools-rpms \
    && \
    yum install -y  openshift-ansible python2-openstacksdk.noarch \
                    python2-shade.noarch python2-openstackclient.noarch \
                    telnet && \
    subscription-manager unregister

    # yum install -y ansible \
    #                openssh-clients.x86_64 \
    #                python2-openstacksdk.noarch \ 
    #                python2-shade.noarch \
    #                python2-openstackclient.noarch \
    #                telnet
    #                # Important for os_loadbalancer
    #                python2-urllib3.noarch  python2-chardet.noarch
#RUN subscription-manager unregister


# Tunnel: ssh -o "DynamicForward 127.0.0.1:65432" -i /work/q-root-id_rsa q.bohne.io -fN
# export ALL_PROXY=socks5h://127.0.0.1:65432
# ENV ALL_PROXY=socks5h://127.0.0.1:65432
