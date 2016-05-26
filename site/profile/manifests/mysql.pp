class profile::mysql {
  include '::mysql::server'

  class { 'mysql::bindings' :
    php_enable => true,
  }
}
