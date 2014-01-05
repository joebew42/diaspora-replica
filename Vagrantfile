# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  #config.vm.box = "ubuntu_server_1204_x64"
  #config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"
  #config.vm.box = "centos_64_x64"
  #config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
  config.vm.box = "boilerplate-centos"
  config.vm.hostname = "development.diaspora.local"
  config.vm.network :private_network, ip: "192.168.11.2"

  #config.vm.provision :shell, :inline => "apt-get update -y --fix-missing"
  config.vm.provision :shell, :inline => "yum -y update"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "site.pp"
    puppet.options = "--verbose"
  end
end
