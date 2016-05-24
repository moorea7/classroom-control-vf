class skeleton {
  file { '/etc/skel' : 
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }
  
  
}
