yum install -y git openshift-ansible screen tmux vim

cp -v /root/.ssh/id_rsa* /home/cloud-user/.ssh/
chown cloud-user:cloud-user /home/cloud-user/.ssh/id_rsa*

echo -e '#!/bin/sh\nexec /usr/bin/ssh -o StrictHostKeyChecking=no "$@"' >> /usr/local/bin/ssh-ignore-key
chmod +x /usr/local/bin/ssh-ignore-key
export GIT_SSH="/usr/local/bin/ssh-ignore-key"

cd /home/cloud-user/

git clone  -b {{ stc_clone_branch | default('master') }} --single-branch {{ stc_clone_url }}

mv -v /tmp/env.yml /home/cloud-user/stc/env.yml
mv -v /tmp/secrets.yml /home/cloud-user/stc/secrets.yml
mv -v /tmp/install-ocp.sh /home/cloud-user/install-ocp.sh


chown -R cloud-user:cloud-user /home/cloud-user/stc/
chown cloud-user:cloud-user /home/cloud-user/install-ocp.sh
chmod +x /home/cloud-user/install-ocp.sh

{% if deploy %}
runuser --user cloud-user /home/cloud-user/install-ocp.sh
{% endif %}
