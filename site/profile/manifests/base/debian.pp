class profile::base::debian {
  class {'::apt':
    apt_update_frequency => 'daily',
    purge_sources_list   => true,
    purge_sources_list_d => true,
  }
  include ::puppetlabs_apt
  class { '::apt::backports':
    pin_priority => 500,
  }
  apt_key { 'puppetlabs':
    ensure => 'present',
    id     => '1054B7A24BD6EC30',
  }
  apt::source { 'debian':
    comment           => 'base debian repos',
    location          => 'http://ftp.us.debian.org/debian',
    release           => 'stable',
    repos             => 'main contrib non-free',
#    required_packages => 'debian-keyring debian-archive-keyring',
    key               => '8B48AD6246925553',
    key_server        => 'subkeys.pgp.net',
    include_src       => false,
    include_deb       => true
  }
  Package {
    require => [Apt::Source['debian'],
                Class['::apt::backports'],
                Class['::puppetlabs_apt']],
  }
}
