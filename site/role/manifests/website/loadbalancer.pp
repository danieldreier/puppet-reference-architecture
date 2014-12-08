class role::website::loadbalancer {
  include profile::base
  include profile::puppet::agent
  include profile::etcd
  include profile::websites::loadbalancer
  notify {"I'm a load balancer!": }
}
