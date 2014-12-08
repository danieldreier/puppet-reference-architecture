# Wrap mysql client class
# This is wrapped in anticipation of wanting to do site-specific client
# configuration
class site::roles::mysql::client {
  class { '::mysql::client':
    package_ensure => 'installed',
  }
}
