# Configure hiera
# this is in a separate class so that it can be run during provisioning
# prior to the first full puppet run
class profile::hiera (
  $datadir = '/root/bullseye-infrastructure-data/hieradata',
){
  class { 'hiera':
    hierarchy => [
      'secrets',
      'secrets_default',
      '%{environment}',
      '"node/%{::fqdn}"',
      'defaults',
      'users',
      'databases',
      'backup',
    ],
    datadir   => $datadir,
  }
}
