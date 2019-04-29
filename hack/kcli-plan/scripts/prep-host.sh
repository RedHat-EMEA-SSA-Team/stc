timedatectl set-timezone UTC
subscription-manager repos \
  --enable=rhel-7-server-extras-rpms \
  --enable=rhel-7-server-ose-{{ version }}-rpms \
  --enable=rhel-7-server-ansible-2.6-rpms
