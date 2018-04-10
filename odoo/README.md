An Odoo Ansible Provisioning Role
=========================================

This an ansible role for provisioning Odoo. It only has been tested with Odoo 10, but it's probably suitable for Odoo 10+ versions.

Requirements
------------

A PostgreSQL server and one user able to create databases in it (Odoo can't connect to the database with `postgres` user).

A python virtualenv to isolate Odoo requirements from the rest of the system.

Role Variables
--------------
Available variables are listed below, along with default values:

    odoo_default_user: odoo
    odoo_default_group: odoo

    odoo_venv_path: /opt/.odoo_venv

    odoo_version: 10.0
    odoo_release: 20170914
    odoo_url: "https://nightly.odoo.com/{{ odoo_version }}/nightly/src/odoo_{{ odoo_version }}.{{ odoo_release }}.tar.gz"

    odoo_path: /opt/odoo
    odoo_download_path: /tmp/odoo_{{ odoo_version }}.{{ odoo_release }}.tar.gz
    odoo_bin_path: "{{ odoo_path }}/build/scripts-2.7/odoo"
    odoo_python_path: "{{ odoo_venv_path }}/bin/python"
    odoo_config_path: /etc/odoo
    odoo_log_path: /var/log/odoo
    odoo_modules_path: /opt/odoo/modules

Dependencies
------------

This role is not depending on other roles (yet).

Example Playbook
----------------

- hosts: odooservers
  roles:
  - { role: odoo }

License
-------

GPVLv3

Author Information
------------------

@ygneo
http://coopdevs.org
