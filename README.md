#diaspora* -Replica

The aim of this project is to provide some tools that can help you to deploy a full [diaspora*] environment through the automation of two tasks:

* The deploy and configuration of the machine with [Vagrant 2] and [Puppet]
* The deploy of Diaspora* itself with [Capistrano 3]

With these two tasks you can automatically set up different environments, from development to production installation.

##How to start a development environment

If you are a developer and you want to try diaspora without messing up your computer by installing and configuring extra packages, you can set up a virtual machine that is executed by Vagrant and then automatically configured by Puppet.
Now that you have a fully configured virtual machine ready to host a diaspora application, will be very easy to deploy it with Capistrano.

###Configure a fake FQDN in your system

Put this entry in your ``/etc/hosts``
```
192.168.11.2    development.diaspora.io
```

###Initialize project

```
git clone https://github.com/joebew42/diaspora-replica.git
cd diaspora_replica
git submodule update --init
```

###Set up the virtual machine with Vagrant/Puppet

```
vagrant up
```
Wait until the virtual machine is automatically setted up with puppet and is up and running.

###Deploy diaspora*
When the virtual machine is up and running, then you can deploy diaspora* on it using Capistrano

```
cd capistrano
cap development deploy
```

Now, your diaspora* installation is up and running, you can go visit it at ``http://development.diaspora.io``

###Start, stop and restart

You can use Capistrano tasks to start, stop or restart diaspora*

```
cap development deploy:start
cap development deploy:stop
cap development deploy:restart
```

##How to simulate a production environment

If you want to simulate a production installation of diaspora*, you can do that simply modifying the ``Vagrantfile`` and the ``puppet/manifests/site.pp``. In your ``Vagrantfile``, you have to specify the *hostname* of the machine to **production.diaspora.io**

###puppet/manifests/site.pp

```puppet
node 'production.diaspora.io' {
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
And edit your ``/etc/hosts`` putting this entry:

```
192.168.11.2    production.diaspora.io
```
After that, execute vagrant:

```vagrant up```

and proceed to deploy diaspora* with capistrano:

```
cd capistrano
cap production deploy
cap production deploy:compile_assets
cap production deploy:restart
```

##How to start a real production environment
If you want to use these tools to deploy a production environment (e.g. stage or production), you have to configure some properties inside ``Vagrantfile``, ``puppet/manifests/site.pp``, ``capistrano/config/deploy/production.rb`` and of course, SSL certs and private/public keys for the server.

###Vagrantfile

You have to configure your ``Vagrantfile`` based on the virtual machine provider you are going to use (e.g. Amazon AWS, DigitalOcean, and other). Please see the [Vagrant Provider Documentation] for detailed instructions. If you are not going to use vagrant you can skip this section and apply puppet manually, or configure a puppet master/agent environment. See the Puppet documentation for more informations.

###puppets/manifests/site.pp

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
Here you have to configure the FQDN, the name of the branch used and the user of the remote server. If you want to specify a different git repository instead of using the official one, you have to edit the ``capistrano/config/deploy.rb``.

### Capistrano public key
In order to allow Capistrano to execute commands on the remote server you need to put in ``capistrano/ssh_keys`` the private and the public keys of the user. The public key should be the same of ``puppet/modules/diaspora/files/diaspora.pub``.

###Deploy diaspora*
Once you have successfully configured the server, you can deploy and start diaspora*

```
cd capistrano
cap production deploy
cap production deploy:compile_assets
cap production deploy:restart
```

##How to contribute this project

This project is under development. There are a lot of things to do. At the moment the Puppet provides support and, has been tested only on Ubuntu 12.04LTS server. It could be useful if someone can test it over other version of Ubuntu, or better, can provide support for other distributions (e.g. CentOS).
The Database section of the Puppet works only with MySQL/MariaDB and properties like hostname and port are not used at the moment. I would like to improve Puppet to include support over other DBMS, like PostgreSQL. Furthermore there a lot of variables of diaspora.yml that are not covered (e.g. mail server configuration, unicorn workers, and more).

  [diaspora*]: https://github.com/diaspora/diaspora
  [Vagrant 2]: http://www.vagrantup.com/
  [Vagrant Provider Documentation]: http://docs.vagrantup.com/v2/providers/index.html
  [Puppet]: http://puppetlabs.com/
  [Capistrano 3]: http://www.capistranorb.com/
