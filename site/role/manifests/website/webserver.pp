class role::website::webserver {
  include profile::base
  include profile::websites::deploy
  include profile::puppet::agent
  include profile::etcd
  include profile::websites::example_com::webserver
  include profile::websites::example_com::memcached
  include profile::websites::example_com::lb_member
}
