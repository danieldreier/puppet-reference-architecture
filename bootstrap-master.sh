#!/bin/bash

# bootstrap initial puppet modules needed to install puppet master
apt-get update
puppet apply -e 'include profile::puppet::bootstrap::r10k' --modulepath /vagrant/site/

puppet cert list --all # create master ssl / ca certs before installing nginx
puppet apply -e 'include profile::puppet::master' --modulepath '/vagrant/site:/etc/puppet/modules'
chown -R puppet:puppet /etc/puppet # needed for puppetmaster to work

service puppetmaster stop
ln -s /var/lib/puppet/ssl/ca/ca_crl.pem /var/lib/puppet/ssl/crl.pem # hack to get around puppet-puppet bug
puppet apply -e 'include profile::puppet::master' --modulepath '/vagrant/site:/etc/puppet/modules'

puppet agent --test --server aio-puppetmaster-vagrant.boxnet
