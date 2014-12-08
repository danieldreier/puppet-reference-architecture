# Class: profile::puppet:vagrant::bootstrap_puppetconf
#
# Configures modulepath so that we can do a real puppet run without an awkward --modulepath paramater that hiera knows anyway
#
class profile::puppet::vagrant::bootstrap_puppetconf {
  $ca         = hiera('pe_ca')
  $manifest   = hiera('pe_manifest')
  $modulepath = hiera('pe_modulepath')
  $parser     = hiera('pe_parser')

  Ini_setting {
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'master',
  }

  ini_setting { 'pe_ca':
    setting => 'ca',
    value   => $ca,
  }

  ini_setting { 'pe_manifest':
    setting => 'manifest',
    value   => $manifest,
  }

  ini_setting { 'pe_modulepath':
    setting => 'modulepath',
    value   => join($modulepath,':'),
  }

  ini_setting { 'basemodulepath':
    setting => 'basemodulepath',
    value   => join($modulepath,':'),
    section => 'main',
  }

  ini_setting { 'pe_parser':
    setting => 'parser',
    value   => $parser,
  }

  ini_setting { 'pe_node_terminus':
    ensure  => absent,
    setting => 'node_terminus',
  }
}
