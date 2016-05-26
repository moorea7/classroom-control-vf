class profile::apache {
  class { 'apache' : 
    port    => '80',
    docroot => '/opt/wordpress',
  }
  class { 'apache::mod::php' : }
}
