# Everything needed to set up a bullseye base webserver
# Wraps apache module, adds firewall and php setup
class profile::etcd (
  $discovery_url,
  ) {

  validate_string($discovery_url)
  class { 'trigger::install::etcd':
    discovery_url => $discovery_url,
    etcd_ip       => $::ipaddress_eth1,
  }

  class {'trigger::watch::etcd':
    require => Class['trigger::install::etcd'],
  }
}
