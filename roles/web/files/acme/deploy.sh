#!/bin/sh -e
#
# Deploy the renewed certificate(s) to services.
#
# Aaron LI
#

reload() {
    local srv="$1"
    local rv=0
    if service ${srv} status >/dev/null 2>&1; then
        echo "Reloading service ${srv} ..."
        service ${srv} reload
        echo "ok"
    else
        echo "WARNING: service ${srv} is not running" >&2
        rv=1
    fi
    return ${rv}
}


restart() {
    local srv="$1"
    local rv=0
    if service ${srv} status >/dev/null 2>&1; then
        echo "Restarting service ${srv} ..."
        service ${srv} restart
        echo "ok"
    else
        echo "WARNING: service ${srv} is not running" >&2
        rv=1
    fi
    return ${rv}
}


echo "============================================================="
dir="${0%/*}"
rv=0
for f in ${dir}/deploy.d/*; do
    if [ -f "${f}" ]; then
        echo "Deploying [${f##*/}] ..."
        . "${f}" || rv=$?
    fi
done
exit ${rv}
