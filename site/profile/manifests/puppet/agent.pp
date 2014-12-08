# Class: profile::puppet::agent
#
class profile::puppet::agent {
  $puppet_server  = hiera('puppet::agent::server')
  $ca_server      = hiera('puppet::agent::server')
  $report_server  = hiera('puppet::agent::server')
  $configtimeout = hiera('puppet::agent::configtimeout')

  validate_string($puppet_server, $ca_server, $report_server, $config_timeout)

  class { 'puppet::agent':
    server        => $puppet_server,
    report_server => $report_server,
    ca_server     => $report_server,
    configtimeout => $configtimeout,
    method        => 'cron',
  }
}
