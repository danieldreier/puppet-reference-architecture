# Class: profile::puppet::master
#
class profile::puppet::master (
  $servertype = 'unicorn'
  ){
  # uncomment this if you use this outside of vagrant
  #$datadir = "${::settings::confdir}/environments/%{environment}/extdata"
  $datadir = "/vagrant/extdata"

  $master_service = $servertype? {
      'unicorn'   => 'unicorn_puppetmaster',
      'passenger' => 'apache2',
  }


  class { '::r10k':
    sources   => {
      'site' => {
        'remote'  => '/vagrant',
        'basedir' => "${::settings::confdir}/environments"
      },
    },
  }

  $hierarchy = [
    'vagrant/%{is_vagrant}',
    'nodes/%{domain}/%{fqdn}',
    'nodes/%{domain}/%{hostname}',
    'domains/%{domain}/groups/%{group}',
    'domains/%{domain}/stages/%{stage}',
    'domains/%{domain}',
    'groups/%{group}/%{function}/%{stage}',
    'groups/%{group}/%{function}',
    'groups/%{group}/%{stage}',
    'groups/%{group}',
    'location/%{whereami}',
    'os/%{osfamily}',
    'common'
  ]

  class { '::hiera':
    hierarchy => $hierarchy,
#   eyaml         => true,
    datadir   => $datadir,
#   eyaml_datadir => $datadir,
    notify    => Service[$master_service],
  }

  class { '::puppet::server':
    directoryenvs    => true,
    basemodulepath   => '/vagrant/site:/vagrant/modules',
    environmentpath  => '$confdir/environments',
    manage_puppetdb  => true,
    reporturl        => "https://${::fqdn}/reports",
    servertype       => $servertype,
    default_manifest => '/vagrant/site.pp',
    parser           => 'future',
    ca               => true,
    stringify_facts  => false,
    reports          => [
      'https',
      'store',
      'puppetdb',
    ],
  }
}
