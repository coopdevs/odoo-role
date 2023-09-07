An Odoo Ansible Provisioning Role
=========================================

This an Ansible role for provisioning Odoo. It supports:
* Odoo 12
* Odoo 11
* Odoo 10

I has not been tested yet with Odoo 13.

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
# Variable to define pip version
odoo_role_pip_version: "23.1.2"
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
# In a multidb environment, where more than one group use the same instance with isolated views,
# each db name must match the DNS name it will accessed from in order for Odoo to direct the queries to the right DB.
odoo_role_odoo_dbs: [ "odoo.some.coop", "erp.another.org" ]
# Only in multidb environment, select DB based on the HTTP Host header.
odoo_role_dbfilter_enabled: true
# This is the password Odoo asks to user allow them to create, delete, etc. DBs
odoo_role_odoo_db_admin_password: 1234
# Whether to populate db with example data or not.
odoo_role_demo_data: false
# Give the chance to select a database before login (when dbfilter disabled), and enable db manager web interface
odoo_role_list_db: false
```

* Odoo HTTP server settings

```yml
# Set this to 127.0.0.1 when Odoo runs behind a reverse proxy
odoo_role_odoo_http_interface: 0.0.0.0
# Set this to true when Odoo runs behind a reverse proxy
odoo_role_odoo_proxy_mode: false
# Specify how many HTTP workers you need (default is 1)
odoo_role_workers: 2
```

* Odoo other server settings

```yml
# Customize the Odoo timeouts
odoo_role_limit_time_cpu: 60
odoo_role_limit_time_real: 120

# Customize the Odoo memory limits
odoo_role_limit_memory_hard: 2684354560
odoo_role_limit_memory_soft: 2147483648
```

* Core modules list to install/update

```yml
# List of modules to install before running the server. "Shared" part is common to all db's, specific db modules goes into their "db" part
odoo_role_odoo_core_modules_dict:
  shared:
    - base
  db1:
    - account
```

* Community modules list to install/update

```yml
# List of modules to install before running the server. "Shared" part is common to all db's, specific db modules goes into their "db" part

odoo_role_odoo_community_modules_dict:
  shared:
    - web_responsive
  db1:
    - mis_reports
```

* Force update odoo modules
In order to force update an odoo module or a list of modules execute provisioning with the command 
```
-e "odoo_role_modules_force_update=['l10n_es']"
```

* Development mode

Odoo has a mode to auto-reload the server when the code changes and read the views from the code to agile the development process. Using the command line parameter [`--dev`](https://www.odoo.com/documentation/12.0/reference/cmdline.html#developer-features) we can run Odoo in a development mode.
```yaml
odoo_role_dev_mode: true
```
If this mode is active, the systemd unit is not created and you need to run the Odoo process manually.
You can start it with the following command:

```sh
$ ./odoo-bin -c /etc/odoo/odoo.conf --dev all
```

* [Rest Framework](https://github.com/OCA/rest-framework/tree/12.0/base_rest) support

If you need to use the Rest Framework and want to start the server in development mode, use:
```yaml
odoo_role_enable_rest_framework: true
```
This option add to the Odoo configuration file the section and option to development mode: https://github.com/OCA/rest-framework/tree/12.0/base_rest#configuration

* [Queue Job](https://github.com/OCA/queue/blob/12.0/queue_job) support

If you need to use the module [queue\_job](https://github.com/OCA/queue/blob/12.0/queue_job), use:
```yaml
odoo_role_enable_queue_job: true
```

This option add to the Odoo configuration file the option to enable queue\_job as a new thread/process: https://github.com/OCA/queue/blob/12.0/queue\_job/README.rst#id12

* Server-wide modules  

If you need to install some wide-server modules apart from `db_filter` and `queue_job`, use:
```yaml
odoo_role_odoo_server_wide_modules: ['module1', 'module2']
```

By default, it configures as a server-wide modules `web` and `base` -as long as they are mandatory from Odoo v12- in every case and `db_filter` and `queue_job` if the corresponding variables are set to `true` .

* Workers configuration

You can also define how many workers you want to use to execute the jobs:
```yaml
odoo_role_channels: root:2
```

* [sentry](https://github.com/OCA/server-tools/tree/12.0/sentry) support

If you want to use the module [setnry](https://github.com/OCA/server-tools/tree/12.0/sentry), use:
```yaml
odoo_role_enable_sentry: true
odoo_role_sentry_dsn: https://your_sentry_url
```

* i18n Overwrite

We can force the i18n overwrite using the next variable:
```yaml
odoo_role_i18n_overwrite: true
```

You can define this var in the inventory or use it when execute a playbook:

```
ansible-playbook playbooks/provision.yml -i ../my-inventory/inventory/hosts --ask-vault-pass --limit=host -e "{odoo_role_i18n_overwrite: true}"
```

* Environment variables

If you need to define a set of environment variables for your server, you can use the `environment_variables` dict var:

```yaml
environment_variables:
  var_name1: "var_value1"
  var_name2: "var_value2"
  var_name3: "var_value3"
```

This option add a file in `/etc/default/odoo` with the vars and add to the Systemd service the `EnvironmentFile` attribute pointing to `/etc/default/odoo.

Role Tags
---------------
#### Using the `only-modules` Tag

This tag helps you install or update Odoo modules without performing a full setup. Run the playbook with the `--tags` option:

```bash
ansible-playbook playbook.yml --tags "only-modules"
```

Odoo modules
------------

#### Deploy
To use Odoo modules (from OCA or custom modules), you need to deploy modules packages to the server. This role manages the modules deployment with `pip`.
In your inventory you can define up to two variables in order to add python packages to the target `requirements.txt` that will be generated.

Define the `odoo_role_odoo_community_packages` variable to install packages not maintained by you. For example when you're deploying an Odoo instance that just requires OCA modules:

```yml
# inventory/group_vars/all.yml
odoo_role_odoo_community_packages:
  - odoo11-addon-contract==11.0.2.1.0
  - odoo11-addon-contract-sale-invoicing==11.0.1.0.0
  - odoo11-addon-contract-variable-qty-timesheet==11.0.1.0.0
  - odoo11-addon-contract-variable-quantity==11.0.1.2.1
```

In some case you want to deploy different versions of the same module to different hosts.
A typical case is when you have developed a custom module and need to deploy a packaged version of it to production but in local development environment you need to install it es editable.
In this case you can define the `odoo_role_odoo_project_packages` variable:
```yml
# inventory/host_vars/production.yml
odoo_role_odoo_project_packages:
  - odoo14-my-custom-module==14.0.0.1.0
```

```yml
# inventory/host_vars/development.yml
odoo_role_odoo_project_packages:
  - '-e file:///opt/odoo_modules/setup/my_custom_module'
```

For backward compatibility, the Ansible template will look first for a `files/requirements.txt` file in your inventory and use it as the source of the template.
If you have a `files/requirements.txt` file defined in your inventory, the two variables just described will not take any effect.

#### Install
Once the modules packages are installed in the server, you need to install them in the Odoo database.

Define a `odoo_role_odoo_community_modules` variable with the list of the modules names you want to install.

```yml
# inventory/group_vars/all.yml
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

Release
-------

To publish a new release: 
- Go to [releases](https://github.com/coopdevs/odoo-role/releases) and click  on `Draft a new release`.
- Create a new tag on `Choose a tag` and update the description with the changelog, as the example below:
```
## What's Changed
* feat: invert add-ons paths order by @oyale in https://github.com/coopdevs/odoo-role/pull/135
* Add pytest and coverage packages to dev environments by @oyale in https://github.com/coopdevs/odoo-role/pull/136


**Full Changelog**: https://github.com/coopdevs/odoo-role/compare/v0.3.4...v0.3.5
```
- After publishing the release go to [`ansible galaxy`](https://galaxy.ansible.com/) to import the new release. You should find the odoo-role repository under `My content`.

License
-------

GPLv3

Author Information
------------------

@ygneo
http://coopdevs.org
