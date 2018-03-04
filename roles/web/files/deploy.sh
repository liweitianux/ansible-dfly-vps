#!/bin/sh -e
#
# Restart the services after renewing the certificate(s) to deploy the
# changed certificate(s).
#
# This script will be weekly executed.  See "/etc/periodic.conf".
#
# Aaron LI
#

# Services to be restarted after ACME certificate update
SERVICES="nginx dovecot postfix"

for srv in ${SERVICES}; do
    echo "ACME deploy: restarting ${srv} ..."
    service ${srv} restart
done
