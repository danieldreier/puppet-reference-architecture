# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

ETCD_DISCOVERY_URL = "https://discovery.etcd.io/839382947dc86deba05e2894723e98e7"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    ### Define options for all VMs ###
    # Using vagrant-cachier improves performance if you run repeated yum/apt updates
    if defined? VagrantPlugins::Cachier
      config.cache.auto_detect = true
    end

    # distro-agnostic puppet install script from https://github.com/danieldreier/puppet-installer
#    config.vm.provision "shell", inline: "curl getpuppet.whilefork.com | bash"
#    config.vm.provision "shell",
 #     inline: "if ls /vagrant/pkg/danieldreier-trigger-*.tar.gz ; then puppet module install /vagrant/pkg/danieldreier-trigger-*.tar.gz; fi"
 #   config.vm.provision "shell",
 #     inline: "rm -rf /etc/puppet/modules/trigger"
 #   config.vm.provision "shell",
 #     inline: "ln -s /vagrant /etc/puppet/modules/trigger"
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512", "--cpus", "4", "--ioapic", "on"]
    end
    config.vm.box = 'puppetlabs/debian-7.6-64-puppet'

    config.vm.define :puppetmaster do |node|
      node.vm.hostname = 'puppetmaster-aio01-vagrant.example.com'
      node.vm.network :private_network, :auto_network => true
      node.vm.provision :hosts
      node.vm.provision "shell",
        inline: "bash /vagrant/bootstrap-master.sh"
    end
    config.vm.define :apachepuppetmaster do |node|
      node.vm.hostname = 'puppetmaster-apache01-vagrant.example.com'
      node.vm.network :private_network, :auto_network => true
      node.vm.provision :hosts
    #  node.vm.provision "shell",
    #    inline: "bash /vagrant/bootstrap-master.sh"
    end
    config.vm.define :lb01 do |node|
      node.vm.hostname = 'website-lb01-vagrant.example.com'
      node.vm.network :private_network, :auto_network => true
      node.vm.provision :hosts
    end
    config.vm.define :lb02 do |node|
      node.vm.hostname = 'website-lb02-vagrant.example.com'
      node.vm.network :private_network, :auto_network => true
      node.vm.provision :hosts
    end
    config.vm.define :web01 do |node|
      node.vm.hostname = 'website-web01-vagrant.example.com'
      node.vm.network :private_network, :auto_network => true
      node.vm.provision :hosts
      node.vm.provision "shell",
        inline: "puppet agent --test --server puppetmaster-aio01-vagrant.example.com --waitforcert 5"
    end
    config.vm.define :web02 do |node|
      node.vm.hostname = 'website-web02-vagrant.example.com'
      node.vm.box = 'puppetlabs/debian-7.6-64-puppet'
      node.vm.network :private_network, :auto_network => true
      node.vm.provision :hosts
      node.vm.provision "shell",
        inline: "puppet agent --test --server puppetmaster-aio01-vagrant.example.com --waitforcert 5"
    end
    config.vm.define :web03 do |node|
      node.vm.hostname = 'website-web03-vagrant.example.com'
      node.vm.box = 'puppetlabs/debian-7.6-64-puppet'
      node.vm.network :private_network, :auto_network => true
      node.vm.provision :hosts
      node.vm.provision "shell",
        inline: "puppet agent --test --server puppetmaster-aio01-vagrant.example.com --waitforcert 5"
    end
end
