define sysvinit::inittab ( $ensure = 'present', $changes = '', $onlyif = '' ) {
  augeas { "/etc/inittab-$name":
    context => '/files/etc/inittab',
    changes => $ensure ? {
      absent => "rm $name",
      default => $changes,
    },
    onlyif => $onlyif,
    require => Package['sysvinit'],
    notify => Exec['inittab_refreshed'],
  }
}
