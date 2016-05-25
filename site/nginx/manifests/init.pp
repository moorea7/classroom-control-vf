class nginx {
  File { 
	mode    => '0644',
	owner   => 'root',
	group   => 'root',
	require => Package['nginx'],
  }
  
  Yumrepo {
    ensure              => present,
    enabled             => '1',
    gpgcheck            => '1',
    priority            => '99',
    skip_if_unavailable => '1',
    gpgkey              => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
    before              => Package['nginx'],
  }

  yumrepo { 'base':
    descr      => 'CentOS-$releasever - Base',
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra',
  }
  
  yumrepo { 'updates':
    descr      => 'CentOS-$releasever - Updates',
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates&infra=$infra',
  }
  
  yumrepo { 'extras':
    descr      => 'CentOS-$releasever - Extras',
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&infra=$infra',
  }
  
  yumrepo { 'centosplus':
    descr      => 'CentOS-$releasever - Plus',
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus&infra=$infra',
  }
  
  package { 'nginx' :
    ensure  => present,
  }

  file { ['/var/www', '/etc/nginx', '/etc/nginx/conf.d'] :
    ensure  => directory,
  }
  
  file { 'configfile' :
  	ensure  => file,
  	path    => '/etc/nginx/nginx.conf',
  	source  => 'puppet:///modules/nginx/nginx.conf',
  }
  
  file { 'serverblock' :
    ensure  => file,
    path    => '/etc/nginx/conf.d/default.conf',
    source  => 'puppet:///modules/nginx/default.conf',
  }
  
  file { 'index.html' :
    ensure  => file,
    path    => '/var/www/index.html',
    source  => 'puppet:///modules/nginx/index.html',
  }
  
  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => File['configfile', 'serverblock'],
    require   => File['index.html'],
  }
}
