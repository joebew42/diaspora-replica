# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Ubuntu Server 12.04 LTS
  config.vm.box = "ubuntu_server_1204_x64"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"
  config.vm.provision :shell, :inline => "apt-get update -y --fix-missing"

  # CentOS 6.4
  #config.vm.box = "centos_64_x64"
  #config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
  #config.vm.provision :shell, :inline => "yum -y update"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "site.pp"
    puppet.options = "--verbose"
  end

  config.vm.define "development" do |dev|
    dev.vm.hostname = "development.diaspora.local"
    dev.vm.network :private_network, ip: "192.168.11.2"
    dev.vm.synced_folder "src/", "/home/vagrant/diaspora_src/", create: true
    dev.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
    end
  end

  config.vm.define "staging" do |stag|
    stag.vm.hostname = "staging.diaspora.local"
    stag.vm.network :private_network, ip: "192.168.11.3"
  end

  config.vm.define "production" do |prod|
    prod.vm.hostname = "production.diaspora.local"
    prod.vm.network :private_network, ip: "192.168.11.4"
  end

end
