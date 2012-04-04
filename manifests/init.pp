class sysvinit {
  case $::operatingsystem {
    /(?i-mx:debian|ubuntu)/: {
      package { 'sysvinit': }
    }
    /(?i-mx:redhat|centos)/: {
      package {
        'sysvinit':
          name => $::lsbmajdistrelease ? {
            '5' => 'SysVinit',
            '6' => 'sysvinit-tools',
          };
        'initscripts': before => Package['sysvinit'];
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
