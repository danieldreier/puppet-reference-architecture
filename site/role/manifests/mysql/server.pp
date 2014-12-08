# Set up a mysql server to support development of bullseye glass infrastructure
# not intended for production use
class site::roles::mysql::server (
  $buffer_pool_size = '128M',
  $query_cache_size = '64M',
  $tmp_table_size   = '64M'
) {
  class { '::mysql::client':
    package_ensure   => 'installed',
  }

  firewall { '101 allow mysql inbound':
    port   => [3306],
    proto  => tcp,
    action => accept,
  }
  create_resources('mysql::db', hiera_hash('databases'))

  class { '::mysql::server':
    require          => Class['::mysql::client'],
    root_password    => $root_password,
    restart          => True,
    service_name     => 'mysql',
    override_options => { 'mysqld' =>
      {
      'max_connections'                 => '1024',
      'max_connections'                 => '1024',
      'innodb_buffer_pool_size'         => $buffer_pool_size,
      'innodb_additional_mem_pool_size' => '20M',
      'bind_address'                    => '0.0.0.0',
      'tmp_table_size'                  => $tmp_table_size,
      'max_heap_table_size'             => '64M',
      'key_buffer_size'                 => '16M',
      'table_cache'                     => '2000',
      'thread_cache'                    => '20',
      'table_definition_cache'          => '4096',
      'table_open_cache'                => '1024',
      'query_cache_type'                => '1',
      'query_cache_size'                => $query_cache_size,
      'innodb_flush_method'             => 'O_DIRECT',
      'innodb_flush_log_at_trx_commit'  => '1',
      'innodb_file_per_table'           => '1',
      'long_query_time'                 => '5',
      'max-allowed-packet'              => '16M',
      'max-connect-errors'              => '1000000',
      }
    },
  }

  # This is the equivalent of running mysql_secure_installation
  class { '::mysql::server::account_security':
    require => Class['::mysql::server'],
  }
}
