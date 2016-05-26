class nginx (
  $root = undef,
) {

  case $::osfamily {
    'redhat', 'debian' : {
      $package        = 'nginx'
      $owner          = 'root'
      $group          = 'root'
      $defaultdocroot = '/var/www'
      $configdir      = '/etc/nginx'
      $logdir         = '/var/log/nginx'
      $svrblockdir    = '/etc/nginx/conf.d'
    }
    'windows' : {
      $package        = 'nginx-service'
      $owner          = 'Administrator'
      $group          = 'Administrators'
      $defaultdocroot = 'C:/ProgramData/nginx/html'
      $configdir      = 'C:/ProgramData/nginx'
      $logdir         = 'C:/ProgramData/nginx/logs'
      $svrblockdir    = 'C:/ProgramData/nginx/conf.d'
    }
    default : {
      fail("Module ${module_name} is not intended to run on ${::osfamily}")
    }
  }

  $docroot = $root ? {
    undef   => $defaultdocroot,
    default => $root,
  }

  $runasuser = $::osfamily ? {
    'redhat'  => 'nginx',
    'debian'  => 'www-data',
    'windows' => 'nobody',
  }

  File {
    mode    => '0644',
    owner   => $owner,
    group   => $group,
    require => Package[$package],
  }

  if $::osfamily == 'RedHat' {
    Yumrepo {
      ensure              => present,
      enabled             => '1',
      gpgcheck            => '1',
      priority            => '99',
      skip_if_unavailable => '1',
      gpgkey              => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
      before              => Package[$package],
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
  }
  package { $package :
    ensure  => present,
  }

  file { [$docroot, $configdir, $svrblockdir] :
    ensure  => directory,
  }

  file { 'configfile' :
    ensure  => file,
    path    => "${configdir}/nginx.conf",
    content  => template('nginx/nginx.conf.erb'),
  }

  file { 'serverblock' :
    ensure  => file,
    path    => "${svrblockdir}/default.conf",
    content  => template('nginx/default.conf.erb'),
  }

  file { 'index.html' :
    ensure  => file,
    path    => "${docroot}/index.html",
    source  => 'puppet:///modules/nginx/index.html',
  }

  service { 'nginx' :
    ensure    => running,
    enable    => true,
    subscribe => File['configfile', 'serverblock'],
    require   => File['index.html'],
  }
}
