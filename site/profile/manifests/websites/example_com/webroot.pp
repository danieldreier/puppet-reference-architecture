class profile::websites::example_com::webroot {
  $site_root       = '/var/www/sites/virtual/example.com'
  $www_root        = "${site_root}/current/drupal"
  $user            = 'deploy'
  $group           = 'www-data'
  include profile::websites::webroot

  file { [ $site_root, "${site_root}/current", $www_root ]:
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
  }

  file { ["${site_root}/shared/default/files",
          "${site_root}/shared/default",
          "${site_root}/shared" ]:
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    require => File[$site_root],
  }
}
