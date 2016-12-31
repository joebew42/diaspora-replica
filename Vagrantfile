# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?('vagrant-puppet-install')
    config.puppet_install.puppet_version = '3.7.3'
  end

  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, inline: "apt-get update -y --fix-missing"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "site.pp"
    puppet.options = "--verbose"
  end

  config.vm.define "development" do |dev|
    dev.vm.hostname = "development.diaspora.local"
    dev.vm.network :private_network, ip: "192.168.11.2"
    dev.vm.synced_folder "src/", "/home/vagrant/diaspora_src/", create: true, type: "nfs"
    dev.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
    end
  end

  config.vm.define "production" do |prod|
    prod.vm.hostname = "production.diaspora.local"
    prod.vm.network :private_network, ip: "192.168.11.4"
    prod.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
    end
  end

end
