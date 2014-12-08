class profile::backports {
  apt::source { 'wheezy-backports':
    location    => 'http://ftp.us.debian.org/debian/',
    release     => 'wheezy-backports',
    repos       => 'main',
  }
}
