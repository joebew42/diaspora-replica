#Diaspora* -Replica

The aim of this project is to provide some tools that can help you to deploy a full [Diaspora*] environment through the automation of two tasks:

* The deploy and configuration of the machine with [Vagrant 2] and [Puppet]
* The deploy of Diaspora* itself with [Capistrano 3]

With these two tasks we can automatically set up different environments, from development to production installation.

##How to start a development environment

If you are a developer and you want to try Diaspora without messing up your computer by installing and configuring extra packages, you can set up a virtual machine that is executed by Vagrant and then automatically configured by Puppet.
Now that you have a fully configured virtual machine ready to host a Diaspora application, will be very easy to deploy it with Capistrano.

###Configure a fake FQDN in your system

Put this entry in your ``/etc/hosts``
```
192.168.11.2    development.diaspora.io
```

###Initialize project

```
git clone git@github.com:joebew42/dispora-replica.git
cd diaspora_replica
git submodule init
git submodule update
```

###Set up the virtual machine with Vagrant/Puppet

```
vagrant up
```
Wait until the virtual machine is automatically setted up with puppet and is up and running.

###Deploy Diaspora*
When the virtual machine is up and running, then you can deploy Diaspora* on it using Capistrano

```
cap development deploy
```
When the deployment process is finished you can start Diaspora*

```
cap development deploy:start
```
Now, your Diaspora* installation is up and running, you can go visit it at ``http://development.diaspora.io``

##How to start a production environment
If you want to use these tools to deploy a production environment (e.g. stage or production), you have to configure some properties inside ``Vagrantfile``, ``puppet/manifests/site.pp`` and, of course inside ``capistrano/config/deploy/production.rb``.

TODO

```
cap staging deploy:assets_precompile
```

##How to contribute this project

TODO

  [Diaspora*]: https://github.com/diaspora/diaspora
  [Vagrant 2]: http://www.vagrantup.com/
  [Puppet]: http://puppetlabs.com/
  [Capistrano 3]: http://www.capistranorb.com/
