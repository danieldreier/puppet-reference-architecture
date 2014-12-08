class profile::nginx {
  class { '::nginx':
    server_tokens    => 'off',
    worker_processes => 'auto',
    vhost_purge      => true,
    confd_purge      => true,
  }
}
