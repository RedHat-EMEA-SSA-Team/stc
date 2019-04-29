#!/usr/bin/env bash

set -e
set -x

cd /home/cloud-user/stc/
ansible-playbook -e sudo_password="" playbooks/validate_config.yml 

# Don't need --ask-vault-pass because we don't run ansible-vaule encrypt ...
# Don't need -k -- we don't have a SSH password
ansible-playbook -i inventory playbooks/prepare_ssh.yml

cd /usr/share/ansible/openshift-ansible/
ansible-playbook -i /home/cloud-user/stc/inventory playbooks/prerequisites.yml
ansible-playbook -i /home/cloud-user/stc/inventory playbooks/deploy_cluster.yml


