node 'webserver', /^web\d+$/, /^www$/ {
  class { '::site::roles::base': }
  class { '::site::roles::mysql::client': }
  class { '::site::roles::mysql::newrelic_agent': }
  class { '::site::roles::newrelic': }
  class { '::site::roles::webserver': }
  class { '::site::roles::webserver::newrelic': }
  class { '::site::roles::backup': }
  class { '::site::roles::backup::restore': }
  class { '::site::roles::backup::create': }
}
node /^staging$/, /^staging\d+$/ {
  class { '::site::roles::base': }
  class { '::site::roles::mysql::client': }
  class { '::site::roles::mysql::newrelic_agent': }
  class { '::site::roles::newrelic': }
  class { '::site::roles::webserver': }
  class { '::site::roles::webserver::newrelic': }
  class { '::site::roles::backup': }
  class { '::site::roles::backup::restore': }
  # TODO : Create a role, for staging, which would implement a cron job to clean up old Cloud Files containers.
  # That cron job would go out each month and delete the Cloud Files containers for anything older than the previous month.
  # (so that we're storing approx 30-60 days of data at all times)
}

node 'dbserver', /^db\d+$/ {
  class { '::site::roles::base': }
  class { '::site::roles::mysql::server': }
}

node 'devserver', /^dev\d+$/ {
  class { '::site::roles::base': }
  class { '::site::roles::mysql::server': } # client is implied
  class { '::site::roles::webserver': }
  class { '::site::roles::backup': }
  class { '::site::roles::backup::restore': }
}

node 'manager' {
  class { '::site::roles::base': }
}

node default {
  alert 'default node, basic configuration without newrelic'
  class { '::site::roles::base': }
  class { '::site::roles::mysql::client': }
  class { '::site::roles::webserver': }
}
