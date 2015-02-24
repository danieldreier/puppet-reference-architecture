class profile::websites::example_com::memcached {
  class { 'profile::memcached':
    max_memory => '25%',
  }
}
