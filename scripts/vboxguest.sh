#!/usr/bin/env bash

mkdir /tmp/virtualbox
VERSION=$(cat /root/.vbox_version)
mount -o loop /root/VBoxGuestAdditions_$VERSION.iso /tmp/virtualbox
sh /tmp/virtualbox/VBoxLinuxAdditions.run
umount /tmp/virtualbox
rmdir /tmp/virtualbox
rm /root/*.iso