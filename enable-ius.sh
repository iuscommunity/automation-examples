#!/bin/bash
#
# Script to setup the IUS public repository on your EL server.
# Tested on CentOS/RHEL 6/7.

set -eu

if [ "$UID" -ne 0 ]; then
    echo 'Error, this script requires root privileges.' >&2
    exit 1
fi

# do we really want to future-unproof this script?
supported_version_check(){
    :
}

if [ -f /etc/system-release-cpe ]; then
    rh_version=$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1 | tr -d '[:alpha:]')
    rh_id=$(cut -d: -f3 /etc/system-release-cpe)
    case "$rh_id" in
        centos)
            :
            ;;
        redhat)
            rh_id=rhel
            ;;
        *)
            echo "unknown EL clone"
            exit 1
            ;;
    esac
    echo "detected $rh_id $rh_version"
    # automatically available and installed as dependency on CentOS
    if [ "$rh_id" = rhel ]; then
        if rpm -q "epel-release-latest-${rh_version}" > /dev/null ; then
            echo 'EPEL already installed'
        else
            yum -y install "https://dl.fedoraproject.org/pub/epel/epel-release-latest-${rh_version}.noarch.rpm"
            rpm --import "/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-$rh_version"
        fi
    fi
    if rpm -q ius-release > /dev/null ; then
        echo 'IUS already installed'
    else
        yum -y install "https://${rh_id}${rh_version}.iuscommunity.org/ius-release.rpm"
        rpm --import /etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY
    fi
else
    echo 'not an EL distro'
    exit 1
fi
