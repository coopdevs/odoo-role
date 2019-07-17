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

This role supports installing Odoo following two different strategies: `git` (from a git repository) and `tar` (a package or compressed release file).

```yml
# Odoo releases download strategy: tar or git
odoo_role_download_strategy: tar

# Vars for tar download strategy
# supported any other formats supported by ansible unarchive, i.e. by unzip or gtar)
# Releases from Odoo.com odoo nightly
odoo_role_odoo_version: 11.0 # not used outside this file
odoo_role_odoo_release: 20190505 # not used outside this file
odoo_role_odoo_url: "https://nightly.odoo.com/{{ odoo_role_odoo_version }}/nightly/src/odoo_{{ odoo_role_odoo_version }}.{{ odoo_role_odoo_release }}.tar.gz"
# Releases from an Odoo comunity backports updated fork
# odoo_role_odoo_release: "11.0_2019-05-05"
# odoo_role_odoo_url: "https://gitlab.com/coopdevs/OCB/-/archive/{{ odoo_role_odoo_release }}/OCB-{{ odoo_role_odoo_release }}.tar.gz"
odoo_role_odoo_download_path: "{{ odoo_role_odoo_path }}/../odoo_releases/odoo_{{ odoo_role_odoo_version }}.{{ odoo_role_odoo_release }}.tar.gz"

# Vars for git download strategy
odoo_role_odoo_git_url: "https://github.com/OCA/OCB.git"
# OCA's OCB, branch 11.0. LTS probably until 14.0 release. 13.0 is scheduled for October 2019.
odoo_role_odoo_git_ref: "11.0"
```

* Users and group

```yml
odoo_role_odoo_user: odoo
odoo_role_odoo_group: odoo
```

* Directories structure

```yml
odoo_role_odoo_venv_path: /opt/.odoo_venv
odoo_role_odoo_path: /opt/odoo
odoo_role_odoo_bin_path: "{{ odoo_role_odoo_path }}/build/scripts-2.7/odoo"
odoo_role_odoo_python_path: "{{ odoo_venv_path }}/bin/python"
odoo_role_odoo_config_path: /etc/odoo
odoo_role_odoo_log_path: /var/log/odoo
odoo_role_odoo_modules_path: /opt/odoo/modules
```

* Databases

```yml
# Array of DBs that the role will create.
odoo_role_odoo_dbs: [ "odoo" ]
# This is the password Odoo asks to user allow them to create, delete, etc. DBs
odoo_role_odoo_db_admin_password: 1234
# Whether to populate db with example data or not.
odoo_role_demo_data: false
# Wether or not to give the chance to select another existing database that has not been filtered by dbfilter
odoo_role_show_db_list: false
```

* Odoo HTTP server settings

```
# Set this to 127.0.0.1 when Odoo runs behind a reverse proxy
odoo_role_odoo_http_interface: 0.0.0.0
# Set this to true when Odoo runs behind a reverse proxy
odoo_role_odoo_proxy_mode: false
```

* Core modules list to install/update

```yml
# Comma-separated list of modules to install before running the server
odoo_role_odoo_core_modules: "base"
```

* Community modules list to install/update

```yml
# Comma-separated list of modules to install before running the server
odoo_role_odoo_community_modules: ""
```

* Other command line parameters

Odoo loads alternative languages at start up. Listing more languages to load will increase the restart/start time, but at the same time it will show that there are more languages available to choose and it will be easy for the user to switch to one of them. Coma separated list of ISO language codes with optional country code ([source](https://github.com/odoo/odoo/blob/c868da4de607d48d27d5cf9852871ed4698627f8/odoo/tools/translate.py#L1191-L1200)). There are translations for [many languages](https://github.com/odoo/odoo/blob/c868da4de607d48d27d5cf9852871ed4698627f8/odoo/tools/translate.py#L1191-L1200).
```yaml
odoo_role_loaded_languages: ca_ES,es_ES # Also available: eu_ES,gl_ES,pt_PT
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

```yml
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
        odoo_role_download_strategy: tar
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
