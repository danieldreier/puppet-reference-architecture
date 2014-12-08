# Class: profile::puppet:vagrant::bootstrap_hiera
#
# Configures hiera during vagrant provisioning so that hiera data is available when puppet runs
#
class profile::puppet::bootstrap::hiera {
  #  include profile::puppet::common::master::hiera
  class { '::hiera':
    hierarchy => $profile::puppet::common::master::hiera::hierarchy,
    datadir   => "/vagrant_src/projects/puppetlabs-modules/extdata/",
  }
}
