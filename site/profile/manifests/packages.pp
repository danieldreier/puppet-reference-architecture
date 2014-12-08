# Install the basic packages every system needs
class site::base::packages {
  case $::operatingsystem {
    'RedHat', 'CentOS': { $basic_packages = [ 'screen', 'nc', 'mtr',
                                      'iotop', 'openssh-clients', 'git' ] }
    /^(Debian|Ubuntu)$/: { $basic_packages = [ 'screen', 'netcat6',
                              'mtr', 'iotop', 'openssh-client', 'git',
                              'apt-file', 'acl', 'python-pip', 'jq', 'ruby-dev', 'patch', 'python-dev', 'libxml2-dev', 'libxslt1-dev', 'libssl-dev' ] }
    default: { $basic_packages = [ 'git', 'acl', 'python-pip', 'jq', 'ruby-dev', 'patch', 'python-dev', 'libxml2-dev', 'libxslt1-dev', 'libssl-dev' ] }
  }
  package { $basic_packages: ensure => 'installed' }
}
