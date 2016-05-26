class profile::apache {
  class { 'apache' : 
    docroot => '/opt/wordpress',
  }
  class { 'apache::mod::php' : }
}
