class nagios::server::hostgroups {
  resources { 'nagios_hostgroup':
    purge => true,
  }

  Nagios_hostgroup <<| |>> {
    mode    => '0644',
    target  => '/etc/nagios3/conf.d/hostgroups.cfg',
    notify  => Service['nagios3'],
    require => Package['nagios3'],
  }
}
