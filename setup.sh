#!/bin/bash

OCP_VERSION=3.11
CNS_NODES=3
ANSIBLE_VERSION=2.6

cat << EOF
 ____ _____ ____
/ ___|_   _/ ___|
\___ \ | || |
 ___) || || |___
|____/ |_| \____|


EOF


echo
echo "Welcome to STC OpenShift Installation Validator"
echo "You find help for these questions here:"
echo "    https://github.com/RedHat-EMEA-SSA-Team/stc/blob/master/docs/bb0.adoc#prepare-configuration-file"

if [ ! -f env.yml ]; then

    echo "Defaults value are shown in []"
    echo


    echo "Please select OCP Version to install: 3.11, 3.10"
    echo "[3.11] 3.10"
    read ocp_version

    case "$ocp_version" in
        3.11|3.10) OCP_VERSION=$ocp_version
            ;;
    esac


    sed -Ei "s/ocp_version: (.*)/ocp_version: \"$OCP_VERSION\"/" playbooks/group_vars/all

    echo "ocp_version: $OCP_VERSION" > env.yml

    echo "*** selected $OCP_VERSION "
    echo



    while  [ -z $api_dns ]
    do
        echo "Please insert Cluster hostname (API DNS):"
        read -r api_dns
    done

    echo "api_dns: $api_dns" >> env.yml

    while  [ -z $apps_dns ]
    do
        echo "Please insert Wilcard DNS for Apps:"
        read -r apps_dns
    done

    echo "apps_dns: $apps_dns" >> env.yml


    echo
    echo "Cluster Topology Setup"
    echo



    while  [ "$flavor" != "standard" -a "$flavor" != "mini" -a "$flavor" != "full" ]
    do
        echo "Please select STC Flavor"
	echo "[standard] mini full"
        read -r flavor
        if [ -z $flavor ]; then
		flavor="standard"
	fi
    done

    echo
    echo "Selected $flavor Flavor"
    echo

    while  [ -z $bastion ]
    do
        echo "Please insert Bastion Node hostname:"
        read -r bastion
    done

    echo "bastion: $bastion" >> env.yml
    echo "lb: $bastion" >> env.yml

    case "$flavor" in
        standard)
             n_masters=3
             n_nodes=3
             ;;
        mini)
             n_masters=1
             n_infranodes=1
             n_nodes=1
             ;;
        full)
             n_masters=3
             n_infranodes=3
             n_nodes=3
             ;;
    esac

    echo "masters:" >> env.yml

    for (( c=1; c<=$n_masters; c++ ))
    do
        while  [ -z $master_i ]
        do
            echo "Please insert Master $c hostname:"
            read -r master_i
        done
        echo "- $master_i" >> env.yml
        [[ "$flavor" == "mini" ]] && cns_hosts+=($master_i)
        master_i=""

    done





    if [ -n "$n_infranodes" ]; then
        echo "infranodes:" >> env.yml

        for (( c=1; c<=$n_infranodes; c++ ))
        do
            while  [ -z $infranode_i ]
            do
                echo "Please insert Infranode $c hostname:"
                read -r infranode_i
            done
            echo "- $infranode_i" >> env.yml
            cns_hosts+=($infranode_i)
            infranode_i=""
        done

    fi


    echo "nodes:" >> env.yml


    for (( c=1; c<=$n_nodes; c++ ))
    do
        while  [ -z $node_i ]
        do
            echo "Please insert Node $c hostname:"
            read -r node_i
        done
        echo "- $node_i" >> env.yml
        [[ "$flavor" != "full" ]] && cns_hosts+=($node_i)
        node_i=""

    done

    echo "cns:" >> env.yml

    for (( c=0; c<$CNS_NODES; c++ ))
    do
        echo "- ${cns_hosts[$c]}" >> env.yml
    done


    echo "Is there any Proxy to use for OpenShift and Container Runtime?"
    echo "y [n]"
    read has_proxy

    if [[ $has_proxy == "y"  ]]; then
        while  [ -z $proxy_http ]
        do
            echo "Please insert HTTP Proxy:"
            read -r proxy_http
        done

        echo "proxy_http: $proxy_http" >> env.yml


        while  [ -z $proxy_https ]
        do
            echo "Please insert HTTPS Proxy:"
            read -r proxy_https
        done

        echo "proxy_https: $proxy_https" >> env.yml

        echo "Please insert No Proxy (leave blank if any, automatically adding localhost,127.0.0.1,.svc)"
        read -r proxy_no

        if [ -n "$proxy_no" ]; then
            echo "proxy_no: $proxy_no" >> env.yml
        fi

        echo "Please insert Proxy Username (leave blank if any)"
        read -r proxy_username

        if [ -n "$proxy_username" ]; then
            echo "proxy_username: $proxy_username" >> env.yml
        fi

        echo "Please insert Proxy Password (leave blank if any)"
        read -r proxy_password

        if [ -n "$proxy_password" ]; then
            echo "proxy_password: $proxy_password" >> env.yml
        fi

    fi

    while  [ -z $container_disk ]
    do
        echo "Please insert host device used container storage. (sdb, vdb...). Using lsblk to get information."
        read -r container_disk
    done

    echo "container_disk: $container_disk" >> env.yml



    while  [ -z $ocs_disk ]
    do
          echo "Please insert host device used for OCS? (sdc, vdc...). Using lsblk to get information."
          read -r ocs_disk
    done

    echo "ocs_disk: $ocs_disk" >> env.yml

    while  [ -z $ssh_user ]
    do
        echo "Please insert SSH username to be used by Ansible:"
        read -r ssh_user
    done

    echo "ssh_user: $ssh_user" >> env.yml

    while [ "$install_logging" != "y" -a "$install_logging" != "n" ]
    do
      echo "Do you want to install Log aggregation (EFK stack)"
      echo "[y] n"
      read -r install_logging
      [[ -z $install_logging ]] && install_logging="y"
    done

    echo "install_logging: $install_logging" >> env.yml

    while [ "$install_metrics" != "y" -a "$install_metrics" != "n" ]
    do
      echo "Do you want to install Metrics (Cassandra-Hawkular stack)"
      echo "[y] n"
      read -r install_metrics
      [[ -z $install_metrics ]] && install_metrics="y"
    done

    echo "install_metrics: $install_metrics" >> env.yml

    echo "Do you want to configure NTP servers? (NTP will be installed anyway if not present)"
    echo "y [n]"
    read ntp

    if [[ $ntp == "y"  ]]; then
        echo "ntp_servers:" >> env.yml
        echo "Please insert number of NTP server to configure, default 1"
        read ntp_servers
        NTP=1
        if [ -n "$ntp_servers" -a "$ntp_servers" -gt 1 -a "$ntp_servers" -lt 6 ]; then
                NTP=$ntp_servers
                echo "zio $ntp_servers"
        fi

        for (( c=1; c<=$NTP; c++ ))
        do
           while  [ -z $ntp_i ]
           do
              echo "Please insert NTP server n.$c:"
              read -r ntp_i
           done
        echo "- $ntp_i" >> env.yml
        ntp_i=""
        done
    fi

    if [ "$OCP_VERSION" == "3.11" ]; then

      echo "Do you have any Authentication Token for the Red Hat Registry? (this avoid plain text password in inventory)"
      echo
      echo "Please refers to the Official Documentation on how to do it:"
      echo "https://docs.openshift.com/container-platform/3.11/install_config/configuring_red_hat_registry.html#install-config-configuring-red-hat-registry"
      echo
      echo "[y] n"
      read registry_token

      if [ -z "$registry_token" ]; then
        echo "Please insert Registry Service Accounts Token Username"
        read -r oreg_token_user
        echo
        echo "registry_token_user: $oreg_token_user" >> env.yml

        echo "Please insert Registry Service Accounts Token"
        read -r oreg_token
        echo "registry_token: $oreg_token" >> env.yml
      fi
    fi

    echo
    echo "Generated configuration:"
    echo
    echo '********************* STC Conf file *********************'
    cat env.yml
    echo '****************** End STC Conf file ********************'
    echo

else
    echo
    echo "A env.yml file di already present"
    echo "These values will be used:"
    echo
    echo '********************* STC Conf file *********************'
    cat env.yml
    echo '****************** End STC Conf file ********************'
    echo
fi

while  [ "$install" != "y" -a "$install" != "n" ];
do
    echo "Do you want to proceed?"
    echo "y n"
    read -r install
done

if [ "$install" == "n" ]; then

    echo "Aborting installation, please restart"
    exit 1
fi

OCP_VERSION=`grep ocp_version env.yml | awk '{print $2;}';`
echo '*** Check enabled repos'
REPOS="Repo ID:   rhel-7-server-ansible-2.5-rpms
Repo ID:   rhel-7-server-extras-rpms
Repo ID:   rhel-7-server-ose-${OCP_VERSION}-rpms
Repo ID:   rhel-7-server-rpms"

if [ "$OCP_VERSION" == "3.10" ]; then
  REPOS="Repo ID:   rhel-7-server-ansible-2.4-rpms
Repo ID:   rhel-7-server-extras-rpms
Repo ID:   rhel-7-server-ose-${OCP_VERSION}-rpms
Repo ID:   rhel-7-server-rpms"
fi

echo -e "$REPOS" | sort > /tmp/stc-repos-should-enabled
sudo  subscription-manager repos --list-enabled | grep 'Repo ID' | sort > /tmp/stc-repos-enabled
diff -Nuar /tmp/stc-repos-should-enabled /tmp/stc-repos-enabled > /tmp/stc-repo-diff
RC_DIFF=$?

if [ $RC_DIFF -ne 0 ]; then
    echo "Please check repos! Diff:"
    cat /tmp/stc-repo-diff
    exit $RC_DIFF;
fi

echo '*** install git and ansible'
sudo yum install -y git ansible tmux nc screen
echo '*** validate given configuration (env.yml)'
ansible-playbook playbooks/validate_config.yml
echo '*** encrypt secrets file'
ansible-vault encrypt secrets.yml
echo '*** enable SSH authentication between hosts'
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i inventory -k --ask-vault-pass playbooks/prepare_ssh.yml
echo '*** copy created inventory as default inventory'
sudo cp inventory /etc/ansible/hosts
