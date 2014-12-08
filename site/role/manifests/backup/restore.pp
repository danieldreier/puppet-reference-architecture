# Install the backup script (bit hacky)
class site::roles::backup::restore (
  $databases     = hiera('databases'),
  $joomla_config = hiera('joomla_config'),
  $joomla_db     = hiera('joomla_db'),
  $pap_db        = hiera('pap_db'),
  $backup        = hiera('backup_destination'),
  $restore_dir   = '/opt/restore',
  $web_dir       = '/var/www/bullseyeglass.com/www',
  # TODO : See if we can instead parse site::roles::webserver::vhosts => bullseye_http => docroot
) {

  file { 'restore_lib.sh':
    path    => '/root/restore_lib.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    content => template('site/restore_lib.sh.erb'),
    require => [File[$restore_dir], File[$web_dir]],
  }

  file { 'restore_www.sh':
    path    => '/root/restore_www.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    content => template('site/restore_www.sh.erb'),
  }

  file { 'restore_databases.sh':
    path    => '/root/restore_databases.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    content => template('site/restore_databases.sh.erb'),
  }

  file { 'restore_config.sh':
    path    => '/root/restore_config.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    content => template('site/restore_config.sh.erb'),
  }

  file { 'restore_dev.sh':
    path    => '/root/restore_dev.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    content => template('site/restore_dev.sh.erb'),
  }

  file { 'restore_all.sh':
    path    => '/root/restore_all.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    content => template('site/restore_all.sh.erb'),
  }

  # TODO : Consider moving elsewhere; it's not really backup related
  file { 'delete_container.sh':
    path    => '/root/delete_container.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    content => template('site/delete_container.sh.erb'),
  }

  file { $restore_dir:
    ensure => 'directory',
  }

}
