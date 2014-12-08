# Install the backup script (bit hacky)
class site::roles::manager {
  $rackspace = hiera('rackspace_credentials')

  file { 'rackspace_credentials.sh':
    path    => '/etc/profile.d/rackspace_credentials.sh',
    owner   => 'root',
    group   => 'vagrant',
    mode    => '0755',
    content => template('site/rackspace_credentials.sh.erb'),
  }

  $system_packages = [ 'git', 'acl', 'python-pip', 'ruby-dev', 'patch',
                      'python-dev', 'libxml2-dev', 'libxslt1-dev',
                      'libssl-dev', 'python-heatclient', 'python-swiftclient',
                      'siege' ]

  package { $system_packages:
    ensure => 'installed',
  }

  $openstack_ruby_tools = [ 'rumm' ]

  package { $openstack_ruby_tools:
    ensure   => 'installed',
    provider => 'gem',
    require  => Package['ruby-dev'],
  }

  file { '.rummrc':
    path => '/home/vagrant/.rummrc',
    content => template('site/rummrc.erb'),
  }

  class { 'apt':
    always_apt_update => true,
  }

  $motd = '

  ======================================
  = Bullseye Glass Rackspace Workbench =
  ======================================

  ** Before attempting to use this toolset, please log in to the Rackspace web UI and create an SSH key. **

  - To validate that Rackspace credentials are set correctly:
  heat stack-list

  - To set up a new environment, use a command like:
  heat stack-create bullseye_stack_01 -f bullseyeglass.template --parameters="environment=staging;hostname=staging.bullseyeglass.com;key_name=keyname"
  :Note: key_name should be changed, to match the key created in the web interface.

  - To view the output of the stack:
  heat stack-show bullseye_stack_01

  - To destroy the stack:
  heat stack-delete bullseye_stack_01

  - To update the bullseye-infrastructure git repo on the deployed server, SSH in as root, cd to /root/bullseye-infrastructure, and run:
      ssh-agent bash -c "ssh-add ~/.ssh/bullseye-infrastructure-id_rsa; git pull"
    To update the bullseye-infrastructure-data repo, cd to /root/bullseye-infrastructure and run:
      ssh-agent bash -c "ssh-add ~/.ssh/bullseye-infrastructure-data-id_rsa; git pull"
    After updating, re-apply puppet with:
      puppet apply /root/bullseye-infrastructure/site/manifests

  ======================================

  - To deploy a new STAGING instance:
  heat stack-create bullseyeglass -f bullseyeglass.template --parameters=""

  --------------------------------------

  - To deploy a new PRODUCTION instance:
  heat stack-create bullseyeglass -f bullseyeglass.template --parameters="environment=production;hostname=www.bullseyeglass.com"

  ======================================

  '

  file { '/etc/motd':
    content => $motd,
  }

  file { 'bullseyeglass.template':
    path    => '/home/vagrant/bullseyeglass.template',
    owner   => 'vagrant',
    group   => 'vagrant',
    content => template('site/bullseyeglass.template.erb'),
  }

  file { 'delete_container.sh':
    path    => '/home/vagrant/delete_container.sh',
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => '0775',
    content => template('site/delete_container.sh.erb'),
  }

  user { 'vagrant':
    ensure => 'present',
    shell => '/bin/bash',
  }

  ssh_authorized_key { 'ben_ssh_key':
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAABJQAAAQEArQ6KXMp9ip8YJRksHJ2VzXt7pKlvqabdiW9dXTCULKsB3uTDdNqGSSDtaJDd4sxsQ3wEJFi5nTom1CzFRo21UHEJAbvik7eWpHI5gJ/AX4eZAhE3vFx2CVGIhcl738BTLRovQoml5rjC8qp328u1bcxXcma8cN4Hn2KyGTd/0mL1laO7KQtSVHwYpHh2qBMy9dAgKbvNJAgUEkZFBg9Dlj7RpCRBCP2Q2+FTsP8rFt7uRhXYHE7JqveBHHdTylCn7YxKC+BHLj3F+eRAiHhEcOW44GkM4S70AoRMp11c5623SgFla0Zn+/hIbWoAxL+GESUTi4TvCTlCea/CPEu2dw==',
    user => 'vagrant',
  }
}
