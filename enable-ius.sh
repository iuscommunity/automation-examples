#!/bin/bash

set -eu

if [[ $UID -ne 0 ]]; then
	echo "this script requires root privileges" >&2
	exit 1
fi

if [[ ! -e /etc/redhat-release ]]; then
	echo "not an EL distro"
	exit 1
fi

RELEASEVER=$(rpm --eval %rhel)

if [[ $RELEASEVER -ne 6 ]] && [[ $RELEASEVER -ne 7 ]]; then
	echo "unsupported OS version"
	exit 1
fi

rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-$RELEASEVER https://repo.ius.io/RPM-GPG-KEY-IUS-$RELEASEVER
yum --assumeyes install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$RELEASEVER.noarch.rpm https://repo.ius.io/ius-release-el$RELEASEVER.rpm
