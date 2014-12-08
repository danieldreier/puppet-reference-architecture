# Class: profile::puppet::master
#
class profile::puppet::master {

  # uncomment this if you use this outside of vagrant
  #$datadir = "${::settings::confdir}/environments/%{environment}/extdata"
  $datadir = "/vagrant/extdata"

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
    notify    => Service['unicorn_puppetmaster'],
  }

  class { '::puppet::server':
    modulepath      => [
      '/vagrant/site',
      '$confdir/modules',
      '$confdir/environments/$environment/modules/site',
      '$confdir/environments/$environment/modules/site/dist',
    ],
    manage_puppetdb => true,
    reporturl       => "https://${::fqdn}/reports",
    servertype      => 'unicorn',
    manifest        => '/vagrant/site.pp',
    ca              => true,
    stringify_facts => false,
    reports         => [
      'https',
      'store',
      'puppetdb',
    ],
  }
}
