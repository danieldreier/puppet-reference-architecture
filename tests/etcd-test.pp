trigger {'refresh load balancers':
  hosts    => [ 'website-web01-vagrant.example.com',
                'website-web02-vagrant.example.com',
                'website-web03-vagrant.example.com', ],
  provider => 'etcd',
}

exec {'/usr/bin/touch /tmp/foo':
  notify => Trigger['refresh load balancers'],
}

