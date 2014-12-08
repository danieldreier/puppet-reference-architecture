# Wrap mysql client class
# This is wrapped in anticipation of wanting to do site-specific client
# configuration
class site::roles::newrelic (
  $license_key   = hiera('site::newrelic::apikey', 'NOKEY'),
  $newrelic_user = hiera('site::newrelic::system_user', 'newrelic')
  ){
  class { '::java': }

  newrelic::server {
    $::hostname:
    newrelic_license_key => hiera('site::newrelic::apikey', 'NOKEY'),
  }

  user { $newrelic_user:
    ensure => 'present',
    shell  => '/bin/false',
    system => true,
  }
}
