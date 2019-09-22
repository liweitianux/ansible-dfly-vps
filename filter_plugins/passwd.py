# Copyright (c) 2018 Aaron LI <aly@aaronly.me>
# MIT License

"""
Custom Ansible template filters to crypt/hash passwords.
"""

import os
import base64
import crypt
import hashlib


def cryptpass(p):
    """
    Crypt the given plaintext password with salted SHA512 scheme,
    which is supported by Linux/BSDs.
    """
    hashtype = "$6$"
    saltlen = 16
    salt = os.urandom(saltlen)
    salt = base64.b64encode(salt)[:saltlen].decode("utf-8")
    return crypt.crypt(p, hashtype+salt)


def dovecot_makepass(p):
    """
    Generate the salted hashed password for Dovecot using the
    SHA512-CRYPT scheme.

    Implement the "doveadm pw -s SHA512-CRYPT" command.

    Dovecot password format: {<scheme>}$<type>$<salt>$<hash>
    """
    scheme = "SHA512-CRYPT"
    cp = cryptpass(p)
    return "{%s}%s" % (scheme, cp)


def znc_makepass(p, method="sha256", saltlen=20):
    """
    Generate the salted hashed password for ZNC configuration.

    Implement the "znc --makepass" command.

    ZNC password format: <method>#<hash>#<salt>
    """
    salt = os.urandom(saltlen)
    salt = base64.b64encode(salt)[:saltlen].decode("utf-8")
    s = p + salt
    h = getattr(hashlib, method)(s.encode("utf-8"))
    return "%s#%s#%s" % (method, h.hexdigest(), salt)


class FilterModule(object):
    def filters(self):
        return {
            "cryptpass": cryptpass,
            "dovecot_makepass": dovecot_makepass,
            "znc_makepass": znc_makepass,
        }
