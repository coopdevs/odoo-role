An Odoo Ansible Provisioning Role
=========================================

This an Ansible role for provisioning Odoo. It has been tested with Odoo 10 and Odoo 11, but it's probably suitable for Odoo 11+ versions.

Requirements
------------

A PostgreSQL(9.5+).

By now this role only supports peer authentication for PostgreSQL database access.

So you need to create a database in PostgreSQL, one user with access to that database, and one system user with same username.

For instance, you can create an `odoo` user in PostgreSQL with access to the created database, and an user named `odoo` in your system.

Role Variables
--------------
Available variables are listed below, along with default values:

* Edition

This role allows to install Odoo in two editions: [Odoo Nightly](http://nightly.odoo.com/) and [OCA/OCB](https://github.com/OCA/OCB.git) edition.

```
# Vars for the Odoo Nightly edition
# odoo_role_odoo_edition: "odoo"
odoo_role_odoo_version: 11.0
odoo_role_odoo_release: 20170914
odoo_role_odoo_url: "https://nightly.odoo.com/{{ odoo_role_odoo_version }}/nightly/src/odoo_{{ odoo_role_odoo_version }}.{{ odoo_role_odoo_release }}.tar.gz"
odoo_role_odoo_download_path: /tmp/odoo_{{ odoo_role_odoo_version }}.{{ odoo_role_odoo_release }}.tar.gz

# Vars for the OCA/OCB edition
# odoo_role_odoo_edition: "oca"
odoo_role_odoo_git_url: "https://github.com/OCA/OCB.git"
# Use the commit SHA of the required version
odoo_role_odoo_head: "8ef3986d58a097a04502d9ca1ee0a860d7230723"
```

* Users and group

```
odoo_role_odoo_user: odoo
odoo_role_odoo_group: odoo


odoo_role_odoo_venv_path: /opt/.odoo_venv
```

* Directories structure

```
odoo_role_odoo_path: /opt/odoo
odoo_role_odoo_bin_path: "{{ odoo_role_odoo_path }}/build/scripts-2.7/odoo"
odoo_role_odoo_python_path: "{{ odoo_venv_path }}/bin/python"
odoo_role_odoo_config_path: /etc/odoo
odoo_role_odoo_log_path: /var/log/odoo
odoo_role_odoo_modules_path: /opt/odoo/modules
```

* Database

```
odoo_role_odoo_db_name: odoo
# This not a DB user password, but a password for Odoo to deal with DB.
odoo_role_odoo_db_admin_password: 1234
# Whether to populate db with example data or not.
# Use boolean values (True or False) instead of strings,
#+ as "" is False, but non-empty strings as "True" and "False" are True.
odoo_role_demo_data: False
```

* Core modules list to install/update

```
# Comma-separated list of modules to install before running the server
odoo_role_odoo_core_modules: "base"
```

* Community modules list to install/update

```
# Comma-separated list of modules to install before running the server
odoo_role_odoo_community_modules: ""
```

Community Roles
---------------

#### Deploy
To use community roles, you need to deploy this modules in the server. This role manage the modules deployment with `pip`.

You can define a `requirements.txt` file to manage the modules and ensure the version installed:

```
# requirements.txt
odoo11-addon-contract==11.0.2.1.0
odoo11-addon-contract-sale-invoicing==11.0.1.0.0
odoo11-addon-contract-variable-qty-timesheet==11.0.1.0.0
odoo11-addon-contract-variable-quantity==11.0.1.2.1
```

> The default the `requirements.txt` file path is `"{{ inventory_dir }}/../files/requirements.txt"`.

# Install
Once the modules are in the server, you need to install them in the database.

Define a `odoo_role_odoo_community_modules` var with the list of the modules names you want to install.

```
# invenotry/group_vars/all.yml
odoo_role_odoo_community_modules: 'contract,contract_sale_invoicing'
```

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
        odoo_role_odoo_db_name: odoo-db
        odoo_role_odoo_db_admin_password: "{{ odoo_admin_password }}"
        odoo_role_odoo_version: 11.0
        odoo_role_odoo_release: 20180424
```

License
-------

GPLv3

Author Information
------------------

@ygneo
http://coopdevs.org
