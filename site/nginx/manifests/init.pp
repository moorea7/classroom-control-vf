class nginx {
  yumrepo { 'base':
    ensure              => 'present',
    descr               => 'CentOS-$releasever - Base',
    enabled             => '1',
    gpgcheck            => '1',
    gpgkey              => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
    mirrorlist          => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra',
    priority            => '99',
    skip_if_unavailable => '1',
    before              => Package['nginx'],
  }
  
  yumrepo { 'updates':
    ensure              => 'present',
    descr               => 'CentOS-$releasever - Updates',
    enabled             => '1',
    gpgcheck            => '1',
    gpgkey              => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
    mirrorlist          => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates&infra=$infra',
    priority            => '99',
    skip_if_unavailable => '1',
    before              => Package['nginx']	,
  }
  
  yumrepo { 'extras':
    ensure              => 'present',
    descr               => 'CentOS-$releasever - Extras',
    enabled             => '1',
    gpgcheck            => '1',
    gpgkey              => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
    mirrorlist          => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&infra=$infra',
    priority            => '99',
    skip_if_unavailable => '1',
    before              => Package['nginx'],
  }
  
  yumrepo { 'centosplus':
    ensure     => 'present',
    descr      => 'CentOS-$releasever - Plus',
    enabled    => '1',
    gpgcheck   => '1',
    gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus&infra=$infra',
    before     => Package['nginx'],
  }
  
  package { 'nginx' :
    ensure  => present,
  }
  
  file { 'docroot' :
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    path   => '/var/www',
  }
  
  file { 'configfile' :
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    path    => '/etc/nginx/nginx.conf',
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
  }
  
  file { 'serverblock' :
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    path    => '/etc/nginx/conf.d/default.conf',
    source  => 'puppet:///modules/nginx/default.conf',
    require => Package['nginx'],
  }
  
  file { 'index.html' :
    ensure  => file,
    path    => '/var/www/index.html',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/nginx/index.html',
  }
  
  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => File['configfile', 'serverblock', 'index.html']
    require   => Package['nginx']
  }
}
