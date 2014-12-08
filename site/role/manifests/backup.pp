class site::roles::backup {

  # anchor pattern ensures this is evaluated before backup::create or restore
  anchor { '::site::roles::backup': }
  Class {
    require => Anchor['::site::roles::backup'],
  }

  $openstack_pip_tools = [ 'python-swiftclient', 'python-keystoneclient' ]

  package { $openstack_pip_tools:
    ensure   => 'installed',
    provider => 'pip',
    require  => [ Package['python-pip'], Class['apt']]
  }

  $openstack_ruby_tools = [ 'rumm' ]

  package { $openstack_ruby_tools:
    ensure   => 'installed',
    provider => 'gem',
    require  => Package['ruby-dev'],
  }

  # pip sometimes installs apt packages, but won't do an apt-get update first
  # setting this makes apt always update before installing anything
  class { '::apt':
    always_apt_update => true,
  }

}
