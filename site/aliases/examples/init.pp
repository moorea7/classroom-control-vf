user { 'root':
  ensure => present,
}

class { 'aliases':
  admin   => 'me@my.domain.com',
  require => User['root'],
}

