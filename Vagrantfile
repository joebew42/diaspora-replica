# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "piasporadirty"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"
  config.vm.host_name = "diaspora.localhost.com"
  config.vm.network :private_network, ip: "192.168.11.2"

  config.vm.provision :shell, :inline => "apt-get update -y --fix-missing"

  config.vm.provision :puppet do |puppet|
     puppet.manifests_path = "puppet"
     puppet.module_path = "puppet/modules"
     puppet.manifest_file  = "site.pp"
     puppet.options = "--verbose"
  end

  config.vm.provider "virtualbox" do |virtualbox|
    virtualbox.customize ["modifyvm", :id, "--memory", 512]
  end
end
