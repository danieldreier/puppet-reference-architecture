#!/bin/bash

# bootstrap initial puppet modules needed to install puppet master
apt-get update
puppet apply -e 'include profile::puppet::bootstrap::r10k' --modulepath /vagrant/site/

puppet cert list --all # create master ssl / ca certs before installing nginx
ln -s /var/lib/puppet/ssl/ca/ca_crl.pem /var/lib/puppet/ssl/crl.pem # hack to get around puppet-puppet bug
puppet apply -e 'include profile::puppet::master' --modulepath '/vagrant/site:/etc/puppet/modules'
chown -R puppet:puppet /etc/puppet # needed for puppetmaster to work

service puppetmaster stop
puppet apply -e 'include profile::puppet::master' --modulepath '/vagrant/site:/etc/puppet/modules'

service unicorn_puppetmaster restart
service nginx restart
puppet agent --test --server puppetmaster-aio01-vagrant.example.com
