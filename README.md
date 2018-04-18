Ansible Playbooks for Personal DragonFly BSD Server
===================================================

**Aaron LI**

Created: 2018-02-14

Introduction
------------
An Ansible playbook to manage a small (even 512 MB RAM) personal VPS to
self-host various services including:
* _DNS_ (NSD for authoritative DNS service)
* _Email_ (Postfix, Dovecot)
* _Web_ (Nginx, acme-client for Let's Encrypt certificates)
* _CalDAV/CardDAV_ (Radicale with uWSGI)
* _Git_ (Web interface via cgit with uWSGI)
* _IRC Bouncer_ (ZNC)

Playbooks
---------
* `bootstrap.yml`:
  Bootstrap the remote host (e.g., a VPS) after installing DragonFly BSD.

  **NOTE**:
  - Use the `bootstrap.sh` script instead.
  - The new host should be configured that allow `root` ssh into it using
    a password. (This will be *disabled* during the bootstrap.)

* `deploy.yml`:
  The main playbook that deploys services on the target host.

Configurations
--------------
* `ansible.cfg`
  Ansible configuration file

* `inventory.yml`
  Remote host specifications

* `group_vars/all/vars.yml`
  Variables for hosts in the `all` group, i.e., all hosts

* `group_vars/all/vault.yml`
  Encrypted variables that will merged into the above `vars.yml` upon
  Ansible playing the playbook.

* `host_vars/vultr`
  Variables specific to this host.

Roles
-----
* `bootstrap`
  Only used in the `bootstrap.yml` playbook to bootstrap a newly installed
  DragonFly BSD host.

* `basic`
  Basic settings, includes:
  - Tune basic services in `/etc/rc.conf`
  - Set some system tunables in `/boot/loader.conf`
  - Enable `/var/log/console.log` in syslog
  - Tune csh/tcsh
  - Tweak pkg and install basic packages

* `security`
  - Setup PF firewall
  - Enable `sshlockout`

* `dns`
  - Setup local DNS cache with [Unbound](https://www.nlnetlabs.nl/projects/unbound/about/)
  - Configure [NSD](https://www.nlnetlabs.nl/projects/nsd/about/) as
    the authoritative name server in *hidden master* mode for several
    personal domains

* `web`
  - Obtain SSL/TLS certificates from *Let's Encrypt*, as well as for other
    services (SMTP, IMAP, CalDAV/CardDAV, ZNC).
  - Serve personal website
  - Serve CalDAV/CardDAV via [Radicale](http://radicale.org/)
  - Serve git repositories via [cgit](https://git.zx2c4.com/cgit/)
  - Useful reverse proxies to popular websites

* `mail`
  - SMTP client & server by [Postfix](http://www.postfix.org/)
  - IMAP server by [Dovecot](https://dovecot.org/)
  - DKIM signing via [OpenDKIM](http://opendkim.org/)
  - SPF, DKIM, DMARC records managed through NSD above
  - Do *not* use database
  - No web interface

* `git`
  - Self-host Git repositories
  - Web interface via [cgit](https://git.zx2c4.com/cgit/)
  - Also manage and deploy the static resources of cgit via a Git repo

* `shadowsocks`
  Setup ShadowSocks-libev for a useful proxy.

* `znc`
  Setup [ZNC](https://wiki.znc.in/ZNC) IRC bouncer connecting to channel
  `#dragonflybsd` on [EFNet](http://www.efnet.org/).

* `radicale`
  Setup [Radicale](http://radicale.org/) as a lightweight CalDAV/CardDAV
  server for personal calendars and contacts.
  Served via Nginx and [uWSGI](http://projects.unbit.it/uwsgi).

Extensions
----------
* `filter_plugins/`
  Custom template filters

References
----------
* Securing a Server with Ansible
  https://ryaneschinger.com/blog/securing-a-server-with-ansible/

License
-------
[The MIT License](https://opensource.org/licenses/MIT)
