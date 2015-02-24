# Configure a memcache server
class profile::memcached (
  # can accept either string percentages or integers to indicate MB memory
  $max_memory = '75%',
  # can make this more restrictive by adding a role to the query, like:
  # query_nodes("Class[Role::Puppetlabs_com::Webserver] and group='${::group}' and stage='${::stage}'", "ipaddress_${::primary_iface}")
  $allowed_ips = unique(query_nodes("group='${::group}' and stage='${::stage}'", "ipaddress_${::primary_iface}")),
  ){

  class { '::memcached':
    max_memory => $max_memory,
  }

  if $profile::server::params::fw {
    validate_array($allowed_ips)
    each($allowed_ips) |$client_ipaddress| {
      firewall { "150 allow memcached access from ${client_ipaddress} in ${::group} ${::stage}}":
        proto  => 'tcp',
        action => 'accept',
        port   => 11211,
        source => $client_ipaddress,
      }
    }
  } else {
    notify {'profile::memcached does not have a firewall enabled. memcached has no security other than the firewall.': }
  }
# disabled because this repo doesn't have metrics yet
#  if $profile::server::params::metrics {
#    Diamond::Collector <| title == 'MemcachedCollector' |>
#  }
}
