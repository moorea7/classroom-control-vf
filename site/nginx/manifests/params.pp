class nginx::params {
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

  $runasuser = $::osfamily ? {
    'redhat'  => 'nginx',
    'debian'  => 'www-data',
    'windows' => 'nobody',
  }
}
