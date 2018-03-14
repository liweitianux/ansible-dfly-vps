#!/bin/sh
#
# This script can be both used to request/obtain new certificate(s) from
# Let's Encrypt through ACME challenges:
#     $ ./acme-client.sh -n -N
# to expand the domains listed in the certificate:
#     $ ./acme-client.sh -e
# and be used to renew the obtained certificate(s) (default action):
#     $ ./acme-client.sh
# which can be called by periodic(8).
#
# This script will be weekly executed in order to renew the certificate(s).
# See "/etc/periodic.conf".
#
# Output files:
#   * .../etc/acme/privkey.pem : account private key
#   * .../etc/ssl/acme/private/<domain>.pem : domain private key
#
# XXX/TODO:
#   * How to remove/revoke a SAN from the certificate?
#
#
# Aaron LI
# 2017-04-19
#

umask 027

BASEDIR="/usr/local/etc/acme"
SSLDIR="/usr/local/etc/ssl/acme"
DOMAINSFILE="${BASEDIR}/domains.txt"
CHALLENGEDIR="/usr/local/www/acme/.well-known/acme-challenge"
# Default to show verbose information
VERBOSE="true"
# Additional arguments for "acme-client"
ARGS=""


usage() {
    cat << _EOF_
usage:
`basename $0` [-h] [-efLnNv] [-d domains.txt]

    -e : allow expanding the domains listed in the certificate
    -f : force updating the certificate signature even if its too soon
    -n : create a new 4096-bit RSA account key if one does not already exist
    -N : create a new 4096-bit RSA domain key if one does not already exist
    -q : be quiet (default to show verbose information)

    -d domains.txt : text file with one domain and its sub-domains per line
                     (default: ${DOMAINSFILE})
_EOF_
}


while getopts "efhnNqd:" opt; do
    case "$opt" in
        h)
            usage
            exit 1
            ;;
        e)
            ARGS="${ARGS} -e"
            ;;
        f)
            ARGS="${ARGS} -F"
            ;;
        n)
            ARGS="${ARGS} -n"
            ;;
        N)
            ARGS="${ARGS} -N"
            ;;
        q)
            VERBOSE="false"
            ;;
        d)
            DOMAINSFILE="${OPTARG}"
            ;;
        [?])
            usage
            exit 2
            ;;
    esac
done

if [ "${VERBOSE}" = "true" ]; then
    ARGS="${ARGS} -v"
fi

# HACK???
[ ! -f "/etc/ssl/cert.pem" ] && \
    ln -sv /usr/local/etc/ssl/cert.pem /etc/ssl/cert.pem

[ ! -d "${CHALLENGEDIR}" ] && mkdir -pv ${CHALLENGEDIR}
[ ! -d "${SSLDIR}/private" ] && mkdir -pvm700 "${SSLDIR}/private"

printf "\n=== $(date) ===\n=== CMD: $0 $* ===\n"

grep -v '^\s*#' "${DOMAINSFILE}" | while read domain line; do
    printf "-------------------------------------------------------------\n"
    printf "[${domain}] ${line}\n"
    printf "-------------------------------------------------------------\n"
    CERTSDIR="${SSLDIR}/${domain}"
    [ ! -d "${CERTSDIR}" ] && mkdir -pm755 "${CERTSDIR}"
    set +e  # RC=2 when time to expire > 30 days
    acme-client -b -C "${CHALLENGEDIR}" \
                -k "${SSLDIR}/private/${domain}.pem" \
                -c "${CERTSDIR}" \
		${ARGS} \
                ${domain} ${line}
    RC=$?
    set -e
    [ $RC -ne 0 -a $RC -ne 2 ] && exit $RC
done

printf "-------------------------------------------------------------\n"
exit 0
