# diaspora*-replica

## Table of contents

1. [Overview - What is diaspora*-replica?](#overview)
2. [Deploy diaspora* on local environment](#deploy-diaspora-on-local-environment)
3. [Deploy diaspora* on production environment](#deploy-diaspora-on-production-environment)
4. [Using PostgreSQL Database](#using-postgresql-database)
5. [How to set up a Development Environment](#how-to-set-up-a-development-environment)
6. [How to upgrade diaspora*-replica](#how-to-upgrade-diaspora-replica)
7. [Which Operating Systems are supported?](#which-operating-systems-are-supported)
8. [How to contribute this project](#how-to-contribute-this-project)
9. [Troubleshooting](#troubleshooting)

## Overview

The aim of this project is to provide a way to automate the provision and the deploy of a [diaspora*] POD through tools like [Vagrant 2], [Puppet] and [Capistrano 3]

- If you are a developer you can use these tools to [setup a development environment](#how-to-set-up-a-development-environment)
- If you are a POD maintainer you can use these tools to automatically provision and configure machines (on a bare-metal server or cloud providers) and deploy diaspora* on it

## Deploy diaspora* on local environment

If you want to try diaspora* without messing up your computer by installing and configuring extra packages, you can set up a virtual machine that is executed by Vagrant and then automatically configured by Puppet.
Now that you have a fully configured virtual machine ready to host a diaspora application, will be very easy to deploy it with Capistrano.

### Configure FQDNs in your system

Vagrantfile, Puppet and Capistrano are already configured to handle two environments: ``development`` and ``production``. If you want to try them you have to update ``/etc/hosts`` file, adding to it the FQDNs for the local diaspora* installation.

Put these entries in your ``/etc/hosts``
```
192.168.11.2    development.diaspora.local
192.168.11.4    production.diaspora.local
```

### Initialize project

```
git clone https://github.com/joebew42/diaspora-replica.git
cd diaspora-replica
git submodule update --init
```

### Install vagrant plugins

```
vagrant plugin install vagrant-puppet-install
```

### Set up the virtual machine with Vagrant/Puppet

```
vagrant up production
```
Wait until the virtual machine is automatically created and configured.

### Install Capistrano with bundle (if you haven't)

If you have not installed Capistrano on your computer, you can easily run bundle to install it.

```
cd capistrano/ && bundle
```

### Deploy diaspora* with Capistrano

When the virtual machine is up and running, then you can deploy diaspora* on it using Capistrano

```
cd capistrano
cap production deploy
```

When executed the first time, this step can take several minutes (about 20, based on your internet connection), because the diaspora git repository must be cloned and the bundler will install ruby gems.
Once capistrano completed the deploy task, you can start diaspora through ``eye``

```
cap production diaspora:eye:start
```

Wait until unicorn workers are ready (about 30/40 seconds) and then your diaspora* installation will be up and running at ``http://production.diaspora.local``

### Start, stop, restart and info

You can use Capistrano tasks to start, stop, restart or get information about diaspora*

```
cap production diaspora:eye:start
cap production diaspora:eye:stop
cap production diaspora:eye:restart
cap production diaspora:eye:info
```

### Deploy other branches

If you want to deploy a different branch of diaspora* (ex. ``develop`` instead of ``master``) you have to update `puppet/manifest/site.pp` by specifying correct `rvm` and `ruby` version:

```puppet
node 'production.diaspora.local' {
  class { 'diaspora':
    hostname            => $fqdn,
    environment         => 'production',
    rvm_version         => '1.26.3',
    ruby_version        => '2.1.5',
    app_directory       => '/home/diaspora',
    user                => 'diaspora',
    group               => 'diaspora',
    db_provider         => 'mysql',
    db_host             => 'localhost',
    db_port             => '3306',
    db_name             => 'diaspora_production',
    db_username         => 'diaspora',
    db_password         => 'diaspora',
    db_root_password    => 'diaspora_root',
    unicorn_worker      => 4,
    sidekiq_concurrency => 5,
    sidekiq_retry       => 10,
    sidekiq_namespace   => 'diaspora'
  }
}
```

Set up the the `repo_url` and/or the `branch` that we want to deploy by editing `capistrano/config/deploy/production.rb`

```ruby
...
set :repo_url, 'https://github.com/diaspora/diaspora.git'
set :branch, 'develop'
...
```

Execute the provision of the machine and the deploy of diaspora*

```
vagrant up production
cd capistrano/
cap production deploy
cap production diaspora:eye:start
```

Check out your diaspora* installation at `http://production.diaspora.local`

## Deploy diaspora* on production environment

If you want to use these tools to deploy a production installation (e.g. staging or production), you have to configure some properties inside ``Vagrantfile``, ``puppet/manifests/site.pp``, ``capistrano/config/deploy/production.rb`` and of course, SSL certs and private/public keys for the server.

### Vagrantfile

You have to configure your ``Vagrantfile`` based on the virtual machine provider you are going to use (e.g. Amazon AWS, DigitalOcean, and other). Please see the [Vagrant Provider Documentation] for detailed instructions. If you are not going to use vagrant you can skip this section and apply puppet manually, or configure a puppet master/agent environment. See the Puppet documentation for more informations.

### puppets/manifests/site.pp

```puppet
node 'myproduction.domain.com' {
  class { 'diaspora':
    hostname            => $fqdn,
    environment         => 'production',
    rvm_version         => '1.26.3',
    ruby_version        => '2.1.5',
    app_directory       => '/home/diaspora',
    user                => 'diaspora',
    group               => 'diaspora',
    db_provider         => 'mysql',
    db_host             => 'localhost',
    db_port             => '3306',
    db_name             => 'diaspora_production',
    db_username         => 'diaspora',
    db_password         => 'diaspora',
    db_root_password    => 'diaspora_root',
    unicorn_worker      => 4,
    sidekiq_concurrency => 5,
    sidekiq_retry       => 10,
    sidekiq_namespace   => 'diaspora'
  }
}
```
Of course, you have to change *myproduction.domain.com* with your real Fully Qualified Domain Name, and adjust settings, if needed.

### Setup the SSL certificate for your server

You have to put the SSL key and certificate in ``puppet/modules/diaspora/files/certs/``. The file names must contain the FQDN followed by .crt and .key. See the examples that already exists.

### Setup the public key of the user

Put in ``puppet/modules/diaspora/files/diaspora.pub`` the public key of the user that will be granted to execute commands from Capistrano.

### Apply Puppet configuration

Now that your Puppet configuration is complete, you have to execute it to your production server. If you use vagrant configured with one of the supported providers it can be done automatically. If you are not able to configure vagrant, you can apply puppet in other ways. But this topic will be not covered here. See the Puppet documentation for this.

### capistrano/config/deploy/production.rb

Here you have to configure the FQDN, the git repository URL, the name of the branch and the user of the remote server.

### Capistrano public key

In order to allow Capistrano to execute commands on the remote server you need to put in ``capistrano/ssh_keys`` the private and the public keys of the user. The public key should be the same of ``puppet/modules/diaspora/files/diaspora.pub``.

### Deploy diaspora* with Capistrano

Once you have successfully configured the server, you can deploy and start diaspora*

```
cd capistrano
cap production deploy diaspora:eye:start
```

## Using PostgreSQL Database

If you want to use PostgreSQL [1] instead of the default MySQL, you can configure it through ``puppet/manifests/site.pp``:

```puppet
node 'development.diaspora.local' {
  class { 'diaspora':
    hostname            => $fqdn,
    environment         => 'development',
    rvm_version         => '1.26.3',
    ruby_version        => '2.1.5',
    app_directory       => '/home/diaspora',
    user                => 'diaspora',
    group               => 'diaspora',
    db_provider         => 'postgresql',
    db_host             => 'localhost',
    db_port             => '5432',
    db_name             => 'diaspora_development',
    db_username         => 'diaspora',
    db_password         => 'diaspora',
    db_root_password    => 'diaspora_root',
    unicorn_worker      => 4,
    sidekiq_concurrency => 5,
    sidekiq_retry       => 10,
    sidekiq_namespace   => 'diaspora'
  }
}
```
note the `db_provider` and `db_port` parameters.

[1] Puppet will install PostgreSQL 9.1

### What if I want to deploy the branch master with Postgresql?

Because of "--deployment" flag that is set up by default in capistrano bundler, it is necessary to fork diaspora* in a personal git repository and bundle it with PostgreSQL support:

```bash
$ DB=postgres bundle
```

Add the generated Gemfile.lock under version control. In ``capistrano/config/deploy/production.rb`` you have to specify your git repository:

```
set :repo_url, 'https://github.com/[your_github_username]/diaspora.git'
set :branch, '[your_branch]'
```

## How to set up a Development Environment

You can use these tools to easly set up a fully development environment for diaspora*. The ``development`` machine is configured within ``Vagrantfile`` with enough RAM (2GB) to run all tests.
In this way you can write code using your preferred IDE or editor (``vim``, ``emacs``, ``eclipse`` and so on) directly from your local environment (the host machine), by executing tests within the ``development`` virtual machine.

### Initialize project

```
git clone https://github.com/joebew42/diaspora-replica.git
cd diaspora-replica
git submodule update --init
```

### Install vagrant plugins

```
vagrant plugin install vagrant-puppet-install
```

### Cloning your git repository in src/ directory

Ensure you have `nfs-server` installed and running on your host. ``Vagrantfile`` is configured to synchronize an host directory (``src/``) with the guest directory (``diaspora_src/``). For better I/O performance read the [Vagrant Synced Folder Documentation]. The first step is to clone your own diaspora* git repository into the local directory ``src``.

```
cd diaspora-replica
git clone your_own_diapora_git_repo src
```

Create a new branch or switch to existing one (eg. `master` or `develop`). Lets say we want to switch to the `develop` branch:

```
cd src/
git checkout develop
cd ..
```

### Run development virtual machine

```
vagrant up development
```

### Enabling vagrant user to use rvm (first time set up)

```
vagrant ssh development
vagrant@development:~$ sudo usermod -aG rvm vagrant && newgrp rvm
vagrant@development:~$ /bin/bash --login
```

### Prepare the Rails application

```
vagrant@development:~$ cd diaspora_src
```

Prepare your configuration files ``diaspora.yml`` and ``database.yml``, put it into ``config/`` directory.

### Configure Rubies and Gemsets

```
vagrant@development:~$ rvm use 2.2
```

The line above is just an example, since you have to remember to choose the right `rubies` accordingly to `.ruby-version` file.

```
vagrant@development:~$ rvm gemset create diaspora_dev
vagrant@development:~$ rvm gemset use diaspora_dev
```

### Install gems and create databases

```
vagrant@development:~$ bundle install --with mysql postgresql
```

If `bundle` fails consider to update it with `gem update bundler`. Or if is not installed run `gem install bundler`.

```
vagrant@development:~$ rake generate:secret_token
vagrant@development:~$ rake db:create
vagrant@development:~$ rake db:migrate
```

### Prepare test environment

```
vagrant@development:~$ rake db:test:prepare
vagrant@development:~$ rake assets:generate_error_pages
```

### Run all tests

```
vagrant@development:~$ bundle exec rake
```

## How to upgrade diaspora*-replica

Follow these steps in order to upgrade an existing installation of diaspora*. In this example we'll consider the ``production`` environment (you can apply the same instructions for ``staging``, ``development`` or user defined environment).

```
cd diaspora-replica/
git pull --rebase origin master
git submodule update

vagrant up production
vagrant provision production --provision-with puppet

cd capistrano/
cap production deploy
cap production diaspora:eye:restart
```

## Which Operating Systems are supported?

* Ubuntu 14.04LTS Server
* Ubuntu 12.04LTS Server
* CentOS 6.4

### Choosing the OS from Vagrantfile

By default the ``Vagrantfile`` is configured to run an Ubuntu 14.04LTS Server box. If you want to switch to Ubuntu 12.04LTS Server or CentOS 6.4, you have to edit the file.

## How to contribute this project

This project is under development. At the moment the Puppet provides support and, has been tested on Ubuntu 14.04LTS Server, Ubuntu 12.04LTS Server and CentOS 6.4. It could be useful if someone can test it over other version of Ubuntu or CentOS, or provides support for other GNU/Linux distributions.
The Database section of the Puppet does not consider parameters like hostname and port at the moment. Furthermore there a lot of variables of diaspora.yml that are not covered (e.g. mail server configuration, unicorn workers, and more).

## Troubleshooting

### Net::SSH::HostKeyMismatch

When I run `cap production deploy` I get this error message:

```
SSHKit::Runner::ExecuteError: Exception while executing as diaspora@production.diaspora.local: fingerprint 83:1c:52:22:d1:9c:86:5b:1b:29:80:17:95:5d:a0:29 does not match for "production.diaspora.local,192.168.11.4"

Net::SSH::HostKeyMismatch: fingerprint 83:1c:52:22:d1:9c:86:5b:1b:29:80:17:95:5d:a0:29 does not match for "production.diaspora.local,192.168.11.4"
```

To solve this problem, remove the host entry from your known hosts

```
ssh-keygen -R production.diaspora.local
```

  [diaspora*]: https://github.com/diaspora/diaspora
  [Vagrant 2]: http://www.vagrantup.com/
  [Vagrant Provider Documentation]: http://docs.vagrantup.com/v2/providers/index.html
  [Vagrant Synced Folder Documentation]: http://docs.vagrantup.com/v2/synced-folders/nfs.html
  [Puppet]: http://puppetlabs.com/
  [Capistrano 3]: http://www.capistranorb.com/
