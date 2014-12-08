# Demo vhost for troubleshooting / setup
# Should be removed from a production setup
class site::roles::webserver::testsite {
  file { [ '/var/www/example.com', '/var/www/example.com/httpdocs' ]:
    ensure => 'directory',
  }

  apache::vhost { 'example.com':
    port            => '81',
    docroot         => '/var/www/example.com/httpdocs',
      serveraliases => [
        'www.example.com',
        'example.com',
        'staging.example.com',
        'shop.example.com',
        'web1.boxnet',
      ],
    override        => 'All',
  }

  file {'index.php':
    ensure  => present,
    path    => '/var/www/example.com/httpdocs/index.php',
    mode    => '0644',
    content => '<?php phpinfo(); ?>',
    require => Apache::Vhost['example.com'],
  }
}
