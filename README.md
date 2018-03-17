Ansible Playbooks for Configuring DragonFly BSD as a Personal Server
====================================================================

Aaron LI

Created: 2018-02-14

Introduction
------------

Playbooks
---------
* `bootstrap.yml`:
  Bootstrap the remote host (e.g., a VPS) after installing DragonFly BSD.

  **NOTE**:
  - Use the `bootstrap.sh` script instead.
  - The new host should be configured that allow `root` ssh into it using
    a password. (This will be disabled during the bootstrap.)

* `deploy.yml`:
  The main playbook that deploy services on the target host.

Roles
-----
* `bootstrap`
* `basic`
* `security`
* `dns`
* `web`
* `mail`
* `shadowsocks`
* `znc`

References
----------
* Securing a Server with Ansible
  https://ryaneschinger.com/blog/securing-a-server-with-ansible/

License
-------
The MIT License
