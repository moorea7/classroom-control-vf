define users::managed_user (
  $username = $title,
  $group = $title,
  $homedir = "/home/$username",
r) {
  user { $username :
    ensure => present,
    gid    => $group,
    home   => $homedir,
  }
  group { $group :
    ensure => present,
  }

  file { $homedir :
    owner => $username,
    group => $group,
  }

}


