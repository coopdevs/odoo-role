An Odoo Ansible Provisioning Role
=========================================

This an ansible role for provisioning Odoo. It has been tested with Odoo 10 and Odoo 11, but it's probably suitable for Odoo 11+ versions.

Requirements
------------

A PostgreSQL(9.5+).

By now this role only supports peer authentication for postgreSQL database access.

So you need to create a database in PostgreSQL, one user with access to that database, and one system user with same username.

For instance, you can create an `odoo` user in PostgreSQL with access to the created database, and an user named `odoo` in your system.

Role Variables
--------------
Available variables are listed below, along with default values:

* Edition

This role allows to install Odoo in two editions: [Odoo Nightly](http://nightly.odoo.com/) and [OCA/OCB](https://github.com/OCA/OCB.git) edition.

    # Vars for the Odoo Nightly edition
    # odoo_edition: "odoo"
    odoo_version: 11.0
    odoo_release: 20170914
    odoo_url: "https://nightly.odoo.com/{{ odoo_version }}/nightly/src/odoo_{{ odoo_version }}.{{ odoo_release }}.tar.gz"

    # Vars for the OCA/OCB edition
    # odoo_edition: "oca"
    odoo_git_url: "https://github.com/OCA/OCB.git"
    odoo_head: "8ef3986d58a097a04502d9ca1ee0a860d7230723"

* Users and group

    odoo_default_user: odoo
    odoo_default_group: odoo

    odoo_venv_path: /opt/.odoo_venv

* Directories structure

    odoo_path: /opt/odoo
    odoo_download_path: /tmp/odoo_{{ odoo_version }}.{{ odoo_release }}.tar.gz
    odoo_bin_path: "{{ odoo_path }}/build/scripts-2.7/odoo"
    odoo_python_path: "{{ odoo_venv_path }}/bin/python"
    odoo_config_path: /etc/odoo
    odoo_log_path: /var/log/odoo
    odoo_modules_path: /opt/odoo/modules

* Database

    odoo_db_name: odoo
    # This not a DB user password, but a password for Odoo to deal with DB.
    odoo_db_admin_password: 1234

* Core modules list to install

    # Comma-separated list of modules to install before running the server
    odoo_core_modules: "base"

Dependencies
------------

This role is not depending on other roles (yet).

Example Playbook
----------------

```yaml
- hosts: odoo_servers
  roles:
    - role: coopdevs.odoo-role
      vars:
        odoo_db_name: odoo-db
        odoo_db_admin_password: "{{ odoo_admin_password }}"
        odoo_version: 11.0
        odoo_release: 20180424
```

License
-------

GPLv3

Author Information
------------------

@ygneo
http://coopdevs.org
