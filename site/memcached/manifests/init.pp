class memcached {
  package { 'memcached' : 
    ensure => installed,
  }
  
  file { 'memcached_config' :
    ensure  => file,
    mode    => '0644',
    user    => 'root',
    group   => 'root',
    path    => '/etc/sysconfig/memcached',
    source  => 'puppet:///modules/memcached/memcached.config',
    require => Package['memcached'],
  }
  
  service { 'memcached' :
    ensure    => running,
    enable    => true,
    subscribe => File['memcached_config'],
  }
    
