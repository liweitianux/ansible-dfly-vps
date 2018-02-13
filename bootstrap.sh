#!/bin/sh
#
# Copyright (c) 2018 Aaron LI
# MIT License
#
# 2018-01-25
#

ROOTDIR="${0%/*}"
PLAYBOOK="${ROOTDIR}/bootstrap.yml"
echo "Playbook directory: ${ROOTDIR}"
echo "Playbook: ${PLAYBOOK}"

SSHDIR="${ROOTDIR}/ssh"
SSHKEY="${SSHDIR}/ansible.key"
if [ -f "${SSHKEY}" ]; then
    echo "ERROR: SSH key already exists: ${SSHKEY}"
    echo "Target machine already been bootstrapped?"
else
    [ ! -d "${SSHDIR}" ] && mkdir -v "${SSHDIR}"
    echo "Generating SSH key ..."
    ssh-keygen -t ed25519 -C "ansible" -f "${SSHKEY}"
    echo "Generated SSH key: ${SSHKEY}"
    echo "Bootstrap target by installing Python2.7 ..."
    ansible vultr -u root \
        -m raw -a "pkg install -y python27"
    ansible-playbook \
        --verbose --diff \
        --ask-pass --ask-become-pass \
        "${PLAYBOOK}"
    echo "Bootstrapped the target machine!"
    ansible vultr -u ansible -m ping
    ansible vultr -u ansible -m command -a whoami
    ansible vultr -u ansible -m command -a whoami -b
fi
