class profile::apache {
  class { 'apache' : }
  class { 'apache::mod::php' : }
}
