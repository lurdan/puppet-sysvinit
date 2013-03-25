class sysvinit {
  case $::osfamily {
    'Debian': {
      package { 'sysvinit': }
    }
    'RedHat': {
      package {
        'initscripts':;
        'sysvinit':
          require => Package['initscripts'],
          name => $::lsbmajdistrelease ? {
            '5' => 'SysVinit',
            '6' => 'sysvinit-tools',
          };
      }
    }
  }
  Package['sysvinit'] -> Sysvinit::Init::Config <| |> -> Service <| |>

  case $::virtual {
    /(?i-mx:openvz|lxc)/: {
      sysvinit::inittab { ['1', '2', '3', '4', '5', '6' ]:
        ensure => 'absent',
      }
    }
  }

  file { '/etc/inittab':
    ensure => present,
    require => Package['sysvinit'],
  }

  exec { 'inittab_refreshed':
    command => '/sbin/telinit q',
    refreshonly => true,
    onlyif => '/usr/bin/test -e /dev/initctl',
  }
}

