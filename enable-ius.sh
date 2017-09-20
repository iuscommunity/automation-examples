#!/bin/bash
#
# Script to setup the IUS public repository on your EL server.
# Tested on CentOS/RHEL 6/7.

# Automatically call sudo as needed if running as non-root user
if [[ $(id -u) -ne 0 && $(id -r -u) -ne 0 ]]; then
	PLEASE="sudo"
else
	PLEASE=""
fi

supported_version_check(){
	case ${RELEASE} in
		6*) echo "EL 6 is supported" ;;
		7*) echo "EL 7 is supported" ;;
		*)
			echo "Unsupported OS version"
			exit 1
			;;
	esac
}

centos_install_epel(){
	# CentOS has epel release in the extras repo
	$PLEASE yum -y install epel-release
	import_epel_key
}

rhel_install_epel(){
	case ${RELEASE} in
		6*) $PLEASE yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm;;
		7*) $PLEASE yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;;
	esac
	import_epel_key
}

import_epel_key(){
	case ${RELEASE} in
		6*) $PLEASE rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6;;
		7*) $PLEASE rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7;;
	esac
}

centos_install_ius(){
	case ${RELEASE} in
		6*) $PLEASE yum -y install https://centos6.iuscommunity.org/ius-release.rpm;;
		7*) $PLEASE yum -y install https://centos7.iuscommunity.org/ius-release.rpm;;
	esac
	import_ius_key
}

rhel_install_ius(){
	case ${RELEASE} in
		6*) $PLEASE yum -y install https://rhel6.iuscommunity.org/ius-release.rpm;;
		7*) $PLEASE yum -y install https://rhel7.iuscommunity.org/ius-release.rpm;;
	esac
	import_ius_key
}

import_ius_key(){
	$PLEASE rpm --import /etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY
}

if [[ -e /etc/redhat-release ]]; then
	RELEASE_RPM=$(rpm -qf /etc/redhat-release)
	RELEASE=$(rpm -q --qf '%{VERSION}' ${RELEASE_RPM})
	case ${RELEASE_RPM} in
		centos*)
			echo "detected CentOS ${RELEASE}"
			supported_version_check
			centos_install_epel
			centos_install_ius
			;;
		redhat*)
			echo "detected RHEL ${RELEASE}"
			supported_version_check
			rhel_install_epel
			rhel_install_ius
			;;
		*)
			echo "unknown EL clone"
			exit 1
			;;
	esac

else
	echo "not an EL distro"
	exit 1
fi
