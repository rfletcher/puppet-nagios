class nagios::nrpe(
  $allowed_hosts = undef,
) {
  ## install

  package { 'nagios-nrpe-server':
    ensure => present,
  }

  ## configure

  Augeas {
    context => '/files/etc/nagios/nrpe.cfg',
    notify  => Service['nagios-nrpe-server'],
    require => Package['nagios-nrpe-server'],
  }

  augeas { 'nrpe.cfg: rm default commands':
    changes => 'rm command',
    onlyif  => 'match command size > 0',
  }

  augeas { 'nrpe.cfg: set dont_blame_nrpe':
    changes => 'set dont_blame_nrpe 1',
    onlyif  => 'match dont_blame_nrpe != 1',
  }

  if( is_array( $allowed_hosts ) ) {
    $real_allowed_hosts = join( $allowed_hosts, ',' )

    augeas { 'nrpe.cfg: set allowed_hosts':
      changes => "set allowed_hosts '${real_allowed_hosts}'",
      onlyif  => "match allowed_hosts != '${real_allowed_hosts}'",
    }
  }

  ## run

  service { 'nagios-nrpe-server':
    ensure  => running,
    enable  => true,
    require => Package['nagios-nrpe-server'],
  }
}
