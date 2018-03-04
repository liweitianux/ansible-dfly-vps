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
    if service ${srv} status >/dev/null 2>&1; then
        echo "ACME deploy: restarting ${srv} ..."
        service ${srv} restart
    else
        echo "ACME deploy: service ${srv} not running"
    fi
done
