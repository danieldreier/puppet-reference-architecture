# this class is broken out from the web server profile to make it easier to
# run a development instance that doesn't have a load balancer setup

class profile::websites::example_com::lb_member {
  $sitename = 'example_com'
  @@::haproxy::balancermember { "${::fqdn}_${sitename}":
    listening_service => $sitename,
    server_names      => $::fqdn,
    ipaddresses       => $::primary_ip,
    ports             => '80',
    tag               => [$sitename, $::stage, $::group],
  }

}

