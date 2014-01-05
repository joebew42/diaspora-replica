# diaspora* -Replica

The aim of this project is to provide some tools that can help you to deploy [diaspora*] pod through the automation of two tasks:

* The deploy and configuration of the machine with [Vagrant 2] and [Puppet]
* The deploy of Diaspora* itself with [Capistrano 3]

With these two tasks you can automatically set up different environments, from development to production installation.

## Deploy a development pod

If you are a developer and you want to try diaspora without messing up your computer by installing and configuring extra packages, you can set up a virtual machine that is executed by Vagrant and then automatically configured by Puppet.
Now that you have a fully configured virtual machine ready to host a diaspora application, will be very easy to deploy it with Capistrano.

### Configure a fake FQDN in your system

Put this entry in your ``/etc/hosts``
```
192.168.11.2    development.diaspora.local
```

### Initialize project

```
git clone https://github.com/joebew42/diaspora-replica.git
cd diaspora_replica
git submodule update --init
```

### Set up the virtual machine with Vagrant/Puppet

```
vagrant up
```
Wait until the virtual machine is automatically setted up with puppet and is up and running.

### Install Capistrano with bundle (if you haven't)

If you have not installed Capistrano on your computer, you can easily run bundle to install it.

```
cd capistrano/ && bundle
```

### Deploy diaspora* with Capistrano
When the virtual machine is up and running, then you can deploy diaspora* on it using Capistrano

```
cd capistrano
cap development deploy deploy:restart
```

Now, your diaspora* installation is up and running, you can go visit it at ``http://development.diaspora.local``

### Start, stop and restart

You can use Capistrano tasks to start, stop or restart diaspora*

```
cap development deploy:start
cap development deploy:stop
cap development deploy:restart
```

## Simulate a production deploy

If you want to simulate a production deploy of diaspora* POD, you can do that simply modifying the ``Vagrantfile`` and the ``puppet/manifests/site.pp``. In your ``Vagrantfile``, you have to specify the *hostname* of the machine to **production.diaspora.local**

### puppet/manifests/site.pp

```puppet
node 'production.diaspora.local' {
  class { 'diaspora':
    hostname           => $fqdn,
    environment        => 'production',
    app_directory      => '/home/diaspora',
    user               => 'diaspora',
    group              => 'diaspora',
    db_provider        => 'mysql',
    db_host            => 'localhost',
    db_port            => '3306',
    db_name            => 'diaspora_production',
    db_username        => 'diaspora',
    db_password        => 'diaspora',
    db_root_password   => 'diaspora_root'
  }
}
```
And edits your ``/etc/hosts`` putting this entry:

```
192.168.11.2    production.diaspora.local
```
After that, execute vagrant:

```vagrant up```

and proceed to deploy diaspora* with capistrano:

```
cd capistrano
cap production deploy deploy:restart
```

## Deploy a real diaspora* POD

If you want to use these tools to deploy a production installation (e.g. staging or production), you have to configure some properties inside ``Vagrantfile``, ``puppet/manifests/site.pp``, ``capistrano/config/deploy/production.rb`` and of course, SSL certs and private/public keys for the server.

### Vagrantfile

You have to configure your ``Vagrantfile`` based on the virtual machine provider you are going to use (e.g. Amazon AWS, DigitalOcean, and other). Please see the [Vagrant Provider Documentation] for detailed instructions. If you are not going to use vagrant you can skip this section and apply puppet manually, or configure a puppet master/agent environment. See the Puppet documentation for more informations.

### puppets/manifests/site.pp

```puppet
node 'myproduction.domain.com' {
  class { 'diaspora':
    hostname           => $fqdn,
    environment        => 'production',
    app_directory      => '/home/diaspora',
    user               => 'diaspora',
    group              => 'diaspora',
    db_provider        => 'mysql',
    db_host            => 'localhost',
    db_port            => '3306',
    db_name            => 'diaspora_production',
    db_username        => 'diaspora',
    db_password        => 'diaspora',
    db_root_password   => 'diaspora_root'
  }
}
```
Of course, you have to change *myproduction.domain.com* with your real Fully Qualified Domain Name, and set up strong password.

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
cap production deploy deploy:restart
```

## Using PostgreSQL Database

If you want to use PostgreSQL [1] instead of the default MySQL, you can configure it through ``puppet/manifests/site.pp``:

```puppet
node 'development.diaspora.local' {
  class { 'diaspora':
    hostname         => $fqdn,
    environment      => 'development',
    app_directory    => '/home/diaspora',
    user             => 'diaspora',
    group            => 'diaspora',
    db_provider      => 'postgres',
    db_host          => 'localhost',
    db_port          => '5432',
    db_name          => 'diaspora_development',
    db_username      => 'diaspora',
    db_password      => 'diaspora',
    db_root_password => 'diaspora_root'
  }
}
```
note the `db_provider` and `db_port` parameters.

And you have to uncomment the line:

```ruby
# set :default_env, { DB: 'postgres' }
```
That is present in your ``capistrano/config/deploy/development.rb``

[1] Puppet will install PostgreSQL 9.1

### PostgreSQL for Staging/Production environments

Because of "--deployment" flag that is set up by default in capistrano bundler, it is necessary to fork diaspora* in a personal git repository and bundle it with PostgreSQL support:

```bash
$ DB=postgres bundle
```

and then add the generated Gemfile.lock under version control. Once you have done that, to enable PostgreSQL you have to uncomment this line,:

```ruby
# set :default_env, { DB: 'postgres' }
```

in ``capistrano/config/deploy/production.rb`` (or ``capistrano/config/deploy/staging.rb``, depends on which stage you are going to deploy.) Of course, you have to specify your git repository, too.

## How to contribute this project

This project is under development. There are a lot of things to do. At the moment the Puppet provides support and, has been tested only on Ubuntu 12.04LTS server. It could be useful if someone can test it over other version of Ubuntu, or better, can provide support for other distributions (e.g. CentOS).
The Database section of the Puppet does not consider parameters like hostname and port at the moment. Furthermore there a lot of variables of diaspora.yml that are not covered (e.g. mail server configuration, unicorn workers, and more).

  [diaspora*]: https://github.com/diaspora/diaspora
  [Vagrant 2]: http://www.vagrantup.com/
  [Vagrant Provider Documentation]: http://docs.vagrantup.com/v2/providers/index.html
  [Puppet]: http://puppetlabs.com/
  [Capistrano 3]: http://www.capistranorb.com/
