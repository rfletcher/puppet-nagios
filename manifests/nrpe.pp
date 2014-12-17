class nagios::nrpe(
  $allowed_hosts = undef,
) {
  ## install

  package { 'nagios-nrpe-server':
    ensure => present,
    before => Service['nagios-nrpe-server'],
  }

  ## configure

  Augeas {
    context => '/files/etc/nagios/nrpe.cfg',
    notify  => Service['nagios-nrpe-server'],
    require => Package['nagios-nrpe-server'],
  }

  augeas { 'nrpe.cfg: update defaults':
    changes => [
      'rm command',
      'set dont_blame_nrpe 1'
    ],
  }

  if( is_array( $allowed_hosts ) ) {
    $real_allowed_hosts = join( $allowed_hosts, ',' )

    augeas { 'nrpe.cfg: set allowed_hosts':
      changes => "set allowed_hosts '${real_allowed_hosts}'",
    }
  }

  ## run

  service { 'nagios-nrpe-server':
    ensure     => running,
    enable     => true,
    hasrestart => true,
  }

  # realize virtual NRPE resources
  ::Nagios::Nrpe::Command <| |>
}
