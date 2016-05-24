class skeleton {
  file { '/etc/skel' : 
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }
  
  file { '/etc/skel/.bashrc' :
    ensure => file,
    mode   => '0644',
    owner  => 'root',
    group  =" 'root',
    source => 'puppet:///modules/skeleton/bashrc',
  }
}
