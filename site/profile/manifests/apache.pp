class profile::apache {
  class { 'apache' : }
  class { 'apache::mod::auth_basic' : }
  class { 'apache::mod::rewrite' : }
  class { 'apache::mod::php' : }
  class { 'apache::mod::mpm_module' : }
}
