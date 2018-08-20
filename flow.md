# STC Flow

Everything is executed on bation host. First of the hosts that have reserved for OCP environment

###  ssh to bastion host

ssh to bastion by what ever means.

### Collect base information and setup environment

Change to privileged user
```
sudo -i
```

Create work dir on bastion
```
mkdir /root/ocppoc
```
Use service http://bit.ly/stc-app to create configuration YAML file about environment base information. Copy YAML content to clipboard and create new file from content.

```
vi /root/ocppoc/env.yml
```

Press `a` then paste content and then `<ESC>` and write `:wq` `<ENTER>`

Download setup scripts and Ansible playbooks
```
cd /root/ocppoc
wget -O stc-latest.tar.gz http://bit.ly/stc-bin
tar -xzvf stc-latest.tar.gz
chmod 777 setup.sh
```

### Setup bastion host and  validate configuration

Validation will ping all given nodes so that you can verify that node and IP address match. Validation also creates Ansible inventory for OCP installation. All files are created to `/root/ocppoc` directory.

NOTE: When you validation your configuration Ansible will ask you vault password. Vault is used to encrypt all sensible data like passwords.

Run setup and validation
```
./setup.sh
```

### Test Ansible inventory and public key authentication

Test that public key authentication works.
```
ansible -i ../inventory all -m ping
```

### Validate nodes and external connections for OCP
Validation playbook will check that nodes have proper resources and Internet connectivity.

```
ansible-playbook -i ../inventory --ask-vault-pass playbooks/validate.yml
```
