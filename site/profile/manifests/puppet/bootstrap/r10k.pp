# install r10k and run it during the puppetmaster bootstrap process
# bootstrap using something like:
# puppet apply -e 'include profile::puppet::bootstrap::r10k' --modulepath /vagrant/site/
class profile::puppet::bootstrap::r10k (
  $puppetfile = '/vagrant/Puppetfile',
  $dir = '/etc/puppet' # installs modules in $dir/modules
){
  package { ['rubygems', 'git']:
    ensure => 'installed'
  }
  package { 'r10k':
    ensure   => 'installed',
    provider => 'gem',
    require  => [Package['rubygems'], Package['git']],
  }

  # Run r10k
  exec { 'run r10k':
    environment => ['HOME=/root',"PUPPETFILE=${puppetfile}"],
    command     => "r10k --verbose info puppetfile install",
    cwd         => $dir,
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    require     => [ Package['git'],
                    Package['r10k'] ],
  }
}
