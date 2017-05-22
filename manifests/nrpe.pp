class nagios::nrpe(
  $ensure         = 'present',
  $allowed_hosts  = undef,
  $package_source = undef,
) {
  ## install

  if $package_source == undef {
    $package_provider = 'apt'
  } else {
    $package_provider    = 'dpkg'
    $real_package_source = '/tmp/nagios-nrpe-server.deb'

    wget::fetch { 'nagios-nrpe-server':
      source      => $package_source,
      destination => $real_package_source,
      before      => Package['nagios-nrpe-server'],
    }

    # remove any version previously installed with apt
    exec { 'remove apt nagios-nrpe-server':
      command => 'dpkg -r nagios-nrpe-server',
      onlyif  => 'dpkg --list nagios-nrpe-server | grep \'^i\' && apt-cache madison nagios-nrpe-server | grep "$(dpkg-query --show nagios-nrpe-server | awk \'{ print $2 }\')"',
      before  => Package['nagios-nrpe-server'],
    } ->

    exec { 'manage /usr/lib/nagios/plugins':
      command => 'mkdir -p /usr/lib/nagios/plugins',
      creates => '/usr/lib/nagios/plugins',
      before  => Package['nagios-nrpe-server'],
    }

    Exec['manage /usr/lib/nagios/plugins'] -> Nagios::Nrpe::Plugin <| |>
  }

  package { 'nagios-nrpe-server':
    ensure   => $ensure,
    provider => $package_provider,
    source   => $real_package_source,
    before   => Service['nagios-nrpe-server'],
  }

  if $::lsbdistid == 'Ubuntu' and versioncmp( $::lsbdistrelease, '16.04' ) >= 0 {
    package { 'nagios-plugins':
      ensure  => $ensure,
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }
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
