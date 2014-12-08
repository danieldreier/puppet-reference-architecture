# Everything needed to set up a bullseye base webserver
# Wraps apache module, adds firewall and php setup
class site::roles::webserver (
  $vhosts = {},
  ) {

  anchor { '::site::roles::webserver': }

  Class {
    require => Anchor['::site::roles::webserver'],
  }

  class { 'apache':
    default_mods        => false,
    default_confd_files => false,
    mpm_module          => 'prefork',
    default_vhost       => false,
    service_name        => 'apache2',
  }

  firewall { '102 allow http':
    port   => [80],
    proto  => tcp,
    action => accept,
  }

  firewall { '103 allow https':
    port   => [443],
    proto  => tcp,
    action => accept,
  }

  include apache::mod::rewrite
  include apache::mod::deflate
  include apache::mod::status
  include apache::mod::ssl

  class { '::site::roles::webserver::php': }

  file { [ '/var/www', '/var/www/.ssh', '/var/www/vhosts' ]:
    ensure => 'directory',
  }

  # we were having problems with puppet not managing the www-data user
  $users = hiera('users_basic')
  $key1 = $users[www-data][ssh_authorized_keys][chris_site_key][key]
  $key2 = $users[www-data][ssh_authorized_keys][ben_site_key][key]
  $key3 = $users[www-data][ssh_authorized_keys][curtis_site_key][key]
  $authorized_keys = "ssh-rsa $key1\nssh-rsa $key2\nssh-rsa $key3\n"
  file { 'authorized_keys':
    path => '/var/www/.ssh/authorized_keys',
    content => $authorized_keys
  }

  create_resources('apache::vhost', $vhosts)

}
