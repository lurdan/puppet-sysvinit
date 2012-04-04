# Usage:
#   sysvinit::init::config { 'puppet':
#     $params => { ''  => '', '' => '', },
#   }
define sysvinit::init::config (
  $changes,
  $onlyif = '',
  $package = false
  ) {
  if $package {
    $pkg_name = $package
  }
  else {
    $pkg_name = $name
  }

  augeas { "sysvinit-init-config-$name":
    context => $::operatingsystem ? {
      /(?i-mx:debian|ubuntu)/ => "/files/etc/default/${name}",
      /(?i-mx:redhat|centos)/ => "/files/etc/sysconfig/${name}",
    },
    changes => $changes,
    onlyif => $onlyif,
    require => Package["$pkg_name"],
    notify => Service["$name"],
  }
}
