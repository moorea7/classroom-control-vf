class nginx (
  $package     = $nginx::params::package,
  $owner       = $nginx::params::owner,
  $group       = $nginx::params::group,
  $docroot     = $nginx::params::docroot,
  $configdir   = $nginx::params::configdir,
  $logdir      = $nginx::params::logdir,
  $svrblockdir = $nginx::params::svrblockdir,
  $runasuser   = $nginx::params::runasuser,
) inherits nginx::params {

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
