class profile::base {
  case $::osfamily {
    'Debian': { include profile::base::debian }
    default: { notify {"osfamily ${::osfamily} unknown to profile::base": } }
  }
  class {'motd':
    enable_ascii_art => true,
    ascii_art_text   => $::hostname,
    ascii_art_font   => 'stampatello',
    fact_list        => [$::fqdn, $::ipaddress, $::virtual, $::stage],
  }
}
