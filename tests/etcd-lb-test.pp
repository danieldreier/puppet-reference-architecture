trigger {'refresh load balancers':
  hosts    => [ 'website-lb01-vagrant.example.com',
                'website-lb02-vagrant.example.com', ],
  provider => 'etcd',
}

exec {'/usr/bin/touch /tmp/foo':
  notify => Trigger['refresh load balancers'],
}

