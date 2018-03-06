#!/usr/bin/env python3
#
# Copyright (c) 2018 Aaron LI
# MIT License
#

"""
Find and hash the plain passwords in "passdb.yml" used to generate
the "passwd" auth database for Dovecot.

The given infile will be updated in place, and the already hashed
passwords are also kept.

NOTE: The "SHA512-CRYPT" scheme is used.
"""

import argparse
import crypt

from ruamel.yaml import YAML

SCHEME = "SHA512-CRYPT"
METHOD = crypt.METHOD_SHA512
yaml = YAML()


def hashpass(word):
    """
    Check the given word, and hash it if it's not hashed.
    """
    if word.startswith("{%s}" % SCHEME):
        # Already hashed
        return word

    salt = crypt.mksalt(METHOD)
    return "{%s}%s" % (SCHEME, crypt.crypt(word, salt))


def main():
    parser = argparse.ArgumentParser(
        description="Find and hash the plain passwords in a YAML file"
    )
    parser.add_argument("infile", help="input passdb.yml")
    args = parser.parse_args()

    data = yaml.load(open(args.infile))
    print("Loaded passdb from file: %s" % args.infile)

    for name, user in data["passdb"].items():
        if "pass" in user:
            oldword = user["pass"]
            user["pass"] = hashpass(oldword)
            if user["pass"] == oldword:
                status = "ok"
            else:
                status = "hashed"
            print("* %s ... [%s]" % (name, status))
        if "devices" in user:
            devices = user["devices"]
            for dev, oldword in devices.items():
                devices[dev] = hashpass(oldword)
                if devices[dev] == oldword:
                    status = "ok"
                else:
                    status = "hashed"
                print("* %s @ %s ... [%s]" % (name, dev, status))

    yaml.dump(data, open(args.infile, "w"))
    print("Dumped hashed passdb to file: %s" % args.infile)


if __name__ == "__main__":
    main()
