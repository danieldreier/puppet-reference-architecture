class profile::websites::example_com::webserver {
  include profile::nginx
  include profile::websites::example_com::webroot

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

  nginx::resource::vhost { 'example.com':
    ensure               => present,
    rewrite_to_https     => false,
    www_root             => $www_root,
    use_default_location => false,
    index_files          => [ 'index.html' ],
    ssl                  => false,
    server_name          => [ 'example.com', 'bar.example.com', 'www.example.com' ],
    access_log           => '/var/log/nginx/example_com_access.log',
    error_log            => '/var/log/nginx/example_com_error.log',
    notify               => Trigger['refresh load balancers'],
    require              => Class['Profile::Websites::Webroot']
  }

}
