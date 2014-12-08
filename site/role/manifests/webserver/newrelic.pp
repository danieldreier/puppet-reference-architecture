# All site-specific PHP settings
# the many augeas settings were extracted from the rackspace configuration
# those settings may not be ideal, they're just inherited
class site::roles::webserver::newrelic (
  $license_key     = hiera('site::newrelic::apikey', 'NOKEY'),
  $default_appname = hiera('site::newrelic::default_appname', 'Default Name')
  ) {

  newrelic::php {
    $::hostname:
      newrelic_license_key      => $license_key,
      newrelic_ini_appname      => $default_appname,
      require                   => [Class['::site::roles::webserver::php'],
                                    Class['::php']],
    }

}
