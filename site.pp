Exec {
  logoutput => 'on_failure',
  path      => '/usr/bin:/usr/sbin:/bin:/sbin',
}
case $::osfamily {
  'Debian': {
    Package { subscribe => Exec['apt_update'] }
  }
}

hiera_include('classes')
