class profile::wordpress {
  class { 'wordpress' : 
    install_dir => '/opt/wordpress',
    install_url => 'http://52.39.77.179/port/31010',
  }
}
