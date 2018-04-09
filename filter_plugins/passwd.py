# Copyright (c) 2018 Aaron LI <aly@aaronly.me>
# MIT License

"""
Custom Ansible template filters to crypt/hash passwords.
"""

import os
import base64
import crypt


def cryptpass(p):
    """
    Crypt the given plaintext password with salted SHA512 scheme,
    which is supported by Linux/BSDs.
    """
    hashtype = "$6$"
    saltlen = 16
    salt = os.urandom(saltlen)
    salt = base64.b64encode(salt)[:saltlen]
    return crypt.crypt(p, hashtype+salt)


class FilterModule(object):
    def filters(self):
        return {
            "cryptpass": cryptpass,
        }
