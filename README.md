An Odoo Ansible Provisioning Role
=========================================

This an ansible role for provisioning Odoo. It only has been tested with Odoo 10, but it's probably suitable for Odoo 10+ versions.

Requirements
------------

A PostgreSQL server compatible with Odoo.

By now this role only supports peer authentication for postgreSQL database access.

So you need to create a database in PostgreSQL, one user with access to that database, and one system user with same username.

For instance, you can create an `odoo` user in PostgreSQL with access to the created database, and an user named `odoo` in your system.

Role Variables
--------------
Available variables are listed below, along with default values:

    odoo_default_user: odoo
    odoo_default_group: odoo

    odoo_venv_path: /opt/.odoo_venv

    odoo_version: 10.0
    odoo_release: 20170914

    odoo_path: /opt/odoo
    odoo_download_path: /tmp/odoo_{{ odoo_version }}.{{ odoo_release }}.tar.gz
    odoo_bin_path: "{{ odoo_path }}/build/scripts-2.7/odoo"
    odoo_python_path: "{{ odoo_venv_path }}/bin/python"
    odoo_config_path: /etc/odoo
    odoo_log_path: /var/log/odoo
    odoo_modules_path: /opt/odoo/modules

    odoo_db_name: odoo

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
