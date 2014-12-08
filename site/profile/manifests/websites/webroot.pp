class profile::websites::webroot {
  $user  = 'www-data'
  $group = 'www-data'

  file { [ '/var/www', '/var/www/sites', '/var/www/sites/virtual' ]:
    ensure => 'directory',
    owner  => $user,
    group  => $group,
  }
}
