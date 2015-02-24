class profile::websites::example_com::webserver {
  include profile::nginx
  include profile::websites::example_com::webroot
  $website = 'example.com'

  $www_root = '/var/www'

  # this requires future parser
  $load_balancers = query_nodes('Class[Role::Website::Loadbalancer]', fqdn)
  trigger {'refresh load balancers':
    hosts    => $load_balancers,
    provider => 'etcd',
  }
  #trigger {'refresh load balancers':
  #  hosts    => [ 'website-lb01-vagrant.example.com',
  #                'website-lb02-vagrant.example.com', ],
  #  provider => 'etcd',
  #}

  nginx::resource::vhost { $website:
    ensure               => present,
    rewrite_to_https     => false,
    www_root             => $www_root,
    use_default_location => false,
    index_files          => [ 'index.html' ],
    ssl                  => false,
    server_name          => [ $website, "www.${website}", "dev.${website}", "stage.${website}" ],
    access_log           => "/var/log/nginx/${website}_access.log",
    error_log            => "/var/log/nginx/${website}_error.log",
    notify               => Trigger['refresh load balancers'],
    require              => Class['Profile::Websites::Webroot']
  }

  nginx::resource::location { '/':
    ensure              => 'present',
    location_custom_cfg => {
      try_files => '$uri @rewrite',
    },
    vhost               => $website,
  }

  nginx::resource::location { '~* ^/sites/default/files/(.+)$':
    ensure              => 'present',
    location_custom_cfg => {
      root      => $shared_base,
      try_files => '/files/$1 /files-backup/$1 @rewrite',
    },
    vhost               => $website,
  }

  cron { 'local files fallback':
    command => "/bin/mountpoint ${shared_base}/files && /usr/bin/rsync -a ${shared_base}/files/ ${shared_base}/files-backup",
    user    => 'root',
    hour    => [2, 14],
    minute  => fqdn_rand(60),
  }

  nginx::resource::location { '@rewrite':
    ensure              => 'present',
    location_custom_cfg => {
      rewrite => '^ /index.php',
    },
    vhost               => $website,
  }

  nginx::resource::location { '~ \.php$':
    ensure              => 'present',
    vhost               => $website,
    fastcgi_split_path  => '^(.+\.php)(/.+)$',
    fastcgi_param       => {
      'SCRIPT_FILENAME' => '$request_filename',
    },
    fastcgi             => "unix:${fpm_socket_file}",
    location_custom_cfg => {
      fastcgi_intercept_errors => 'on',
      fastcgi_connect_timeout  => '3m',
      fastcgi_read_timeout     => '3m',
      fastcgi_send_timeout     => '3m',
    },
  }

  nginx::resource::location { '/robots.txt':
    ensure              => 'present',
    location_custom_cfg => {
      access_log => 'off',
      allow      => 'all',
    },
    vhost               => $website,
  }

  nginx::resource::location { '~* \.(js|css|png|jpg|jpeg|gif|ico)$':
    ensure              => 'present',
    location_custom_cfg => {
      expires       => 'off',
      log_not_found => 'off',
    },
    vhost               => $website,
  }

  nginx::resource::location { '~ ^/(fpm-status|ping)$':
    ensure  => 'present',
    location_cfg_prepend => {
      allow      => '127.0.0.1',
      deny       => 'all',
      access_log => 'off',
    },
    vhost   => $website,
    fastcgi => "unix:${fpm_socket_file}",
  }

}
