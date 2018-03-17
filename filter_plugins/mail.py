# Copyright (c) 2018 Aaron LI <aly@aaronly.me>
# MIT License

"""
Custom Ansible template filters for "mail" role.
"""

import os
import base64
import crypt


def dovecot_makepass(p):
    """
    Generate the salted hashed password for Dovecot using the
    SHA512-CRYPT scheme.

    Implement the "doveadm pw -s SHA512-CRYPT" command.

    Dovecot password format: {<scheme>}$<type>$<salt>$<hash>
    """
    method, htype = "SHA512", "$6$"
    scheme = method + "-CRYPT"
    saltlen = 16
    salt = os.urandom(saltlen)
    salt = base64.b64encode(salt)[:saltlen]
    return "{%s}%s" % (scheme, crypt.crypt(p, htype+salt))


class FilterModule(object):
    def filters(self):
        return {
            "dovecot_makepass": dovecot_makepass,
        }
