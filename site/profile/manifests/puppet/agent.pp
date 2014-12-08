# Class: profile::puppet::agent
#
class profile::puppet::agent {
  $puppet_server  = hiera('puppet::agent::server')
  $ca_server      = hiera('puppet::agent::server')
  $report_server  = hiera('puppet::agent::server')
  $configtimeout  = hiera('puppet::agent::configtimeout')
  $stringifyfacts = hiera('puppet::agent::stringify_facts')

  validate_string($puppet_server)
  validate_string($ca_server)
  validate_string($report_server)
  validate_string($configtimeout)
  validate_string($stringifyfacts)

  class { '::puppet::agent':
    server          => $puppet_server,
    report_server   => $report_server,
    ca_server       => $report_server,
    configtimeout   => $configtimeout,
    stringify_facts => $stringifyfacts,
    method          => 'cron',
    parser          => 'future',
  }
}
