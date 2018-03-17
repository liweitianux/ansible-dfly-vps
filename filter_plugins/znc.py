# Copyright (c) 2018 Aaron LI <aly@aaronly.me>
# MIT License

"""
Custom Ansible template filters for "znc" role.
"""

import os
import base64
import hashlib


def znc_makepass(p, method="sha256", saltlen=20):
    """
    Generate the salted hashed password for ZNC configuration.

    Implement the "znc --makepass" command.

    ZNC password format: <method>#<hash>#<salt>
    """
    salt = os.urandom(saltlen)
    salt = base64.b64encode(salt)[:saltlen]
    s = p + salt
    h = getattr(hashlib, method)(s)
    return "%s#%s#%s" % (method, h.hexdigest(), salt)


class FilterModule(object):
    def filters(self):
        return {
            "znc_makepass": znc_makepass,
        }
