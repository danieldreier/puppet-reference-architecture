# Install the backup script (bit hacky)
class site::roles::backup::create (
  $backup    = hiera('backup_destination'),
  $databases = hiera('databases'),
  $web_dir   = '/var/www/bullseyeglass.com/www',
) {

  file { 'backup.sh':
    path    => '/opt/backup/backup.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0770',
    content => template('site/backup.sh.erb'),
    require => [File[$web_dir],File['/opt/backup']],
  }

  file { '/opt/backup':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0770',
  }

  cron { 'backup':
    command => '/bin/bash /opt/backup/backup.sh',
    user    => root,
    hour    => '*/4',
    minute  => 0,
    require => File['backup.sh'],
  }


}
