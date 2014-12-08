class profile::websites::loadbalancer {
  include profile::haproxy

  haproxy::frontend { 'websites':
    ipaddress => '0.0.0.0', # needed due to an apparent bug in puppetlabs-haproxy
    ports     => '80',
    # the acl settings below are needed to route https traffic to different
    # backends based on SNI rather than using a dedicated IP for each vhost
    options   => {
      'acl'         => [
        'EXAMPLE hdr(Host) -i example.com',
      ],
      # the setting below will need to be expanded if more sites use this LB
      'use_backend' => [
        'example_com if EXAMPLE',
      ],
    }
  }

  haproxy::backend { 'example_com':
    options => {
      'option'  => [
        'httplog',
      ],
      'balance' => 'roundrobin',
      'mode'    => 'http',
    },
  }

  Haproxy::Balancermember <| title != $::fqdn and listening_service == 'example_com' and stage == $::stage and group == $::group |>
}
