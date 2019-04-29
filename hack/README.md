# README

This directory contains helper script for STC development.


## kcli plan

What is kcli: https://github.com/karmab/kcli

```
$ kcli plan -f hack/kcli-plan/mini.yml stc
[ snipped ]
$ kcli list
+---------------------+--------+------------+----------------------------------+------+---------+--------+
|         Name        | Status |    Ips     |              Source
| Plan | Profile | Report |
+---------------------+--------+------------+----------------------------------+------+---------+--------+
| bastion.example.com |   up   | 10.88.3.2  | rhel-server-7.6-x86_64-kvm.qcow2
| stc  |  kvirt  |        |
|   i01.example.com   |   up   | 10.88.3.50 | rhel-server-7.6-x86_64-kvm.qcow2
| stc  |  kvirt  |        |
|   m01.example.com   |   up   | 10.88.3.30 | rhel-server-7.6-x86_64-kvm.qcow2
| stc  |  kvirt  |        |
|   n01.example.com   |   up   | 10.88.3.40 | rhel-server-7.6-x86_64-kvm.qcow2
| stc  |  kvirt  |        |
+---------------------+--------+------------+----------------------------------+------+---------+--------+
```

### Full automated setup

Create `kcli-parameters.yml`
```
---
stc_clone_url: https://github.com/rbo/stc.git
stc_clone_branch: devel
deploy: true
api_dns: api.example.com
apps_dns: apps.example.com
install_logging: y
install_metrics: y
registry_token_user: nnnn|username
registry_token: $TOKEN$
```

Run kcli
```
kcli plan \
  --paramfile /workdir/kcli-parameters.yml \
  -f hack/kcli-plan/mini.yml \
  stc
```
