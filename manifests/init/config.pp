# Usage:
#   sysvinit::init::config { 'puppet':
#     $params => { ''  => '', '' => '', },
#   }
define sysvinit::init::config (
  $changes,
  $onlyif = '',
  $package = $name
  ) {

  augeas { "sysvinit-init-config-$name":
    context => $::osfamily ? {
      'Debian' => "/files/etc/default/${name}",
      'RedHat' => "/files/etc/sysconfig/${name}",
    },
    changes => $changes,
    onlyif => $onlyif,
  }

  if $package != 'none' {
    Package["$package"] -> Augeas["sysvinit-init-config-$name"] -> Service["$name"]
  }
}
