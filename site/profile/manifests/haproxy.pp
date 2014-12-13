class profile::haproxy {
  include profile::backports

  class { '::haproxy':
    global_options   => {
      'log'     => "${::ipaddress} local0",
      'chroot'  => '/var/lib/haproxy',
      'pidfile' => '/var/run/haproxy.pid',
      'maxconn' => '4000',
      'user'    => 'haproxy',
      'group'   => 'haproxy',
      'daemon'  => '',
      'stats'   => 'socket /var/lib/haproxy/stats',
    },
    defaults_options => {
      'mode'    => 'http',
      'log'     => 'global',
      'stats'   => 'enable',
      'option'  => [
        'redispatch',
        'httplog',
      ],
      'retries' => '3',
      'balance' => 'roundrobin',
      'timeout' => [
        'http-request 10s',
        'queue 1m',
        'connect 10s',
        'client 1m',
        'server 1m',
        'check 10s'
      ],
      'maxconn' => '8000'
    },
    require => Class['profile::backports'],
  }

}
