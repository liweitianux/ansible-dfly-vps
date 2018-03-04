# Credit: https://github.com/kgaughan/zones

"""
Custom Ansible template filters for DNS management.
"""

import os
import datetime
import random
import shlex
import subprocess


def which(cmd):
    for path in os.environ["PATH"].split(os.pathsep):
        full_path = os.path.join(path, cmd)
        if os.access(full_path, os.X_OK):
            return full_path
    return None


def run_query(cmd, rtype, fqdn, ns=None):
    if not fqdn.endswith("."):
        fqdn += "."
    args = [cmd, fqdn, rtype]
    if ns:
        args.append("@" + ns)

    output = subprocess.check_output(args, universal_newlines=True)
    for line in output.split("\n"):
        if line.startswith(";"):
            continue
        parsed = shlex.split(line)
        if len(parsed) > 0 and parsed[0] == fqdn and parsed[3] == rtype:
            yield parsed[4:]


def next_serial(fqdn):
    """
    Generate the next serial number for the DNS SOA record.
    """
    for cmd in ["drill", "dig"]:
        cmd_path = which(cmd)
        if cmd_path:
            break
    if cmd_path is None:
        raise Exception("Cannot find %s" % cmd)

    def query_nameservers(fqdn, ns=None):
        return [line[0] for line in run_query(cmd_path, "NS", fqdn, ns)]

    # Get a registry nameserver.
    reg_ns = random.choice(query_nameservers(".".join(fqdn.split(".")[1:])))

    nss = query_nameservers(fqdn, reg_ns)
    random.shuffle(nss)

    current_serial = None
    for ns in nss:
        try:
            for line in run_query(cmd_path, "SOA", fqdn, ns):
                current_serial = line[2]
                break
        except subprocess.CalledProcessError as e:
            if e.returncode not in [9]:
                raise
        if current_serial is not None:
            break

    today = datetime.datetime.utcnow().strftime("%Y%m%d")
    if current_serial is None or current_serial[:8] != today:
        return today + "00"
    else:
        return str(int(current_serial) + 1)


class FilterModule(object):
    def filters(self):
        return {"next_serial": next_serial}
