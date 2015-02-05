class nagios::server::contactgroups {
  resources { 'nagios_contactgroup':
    purge => true,
  }

  # collect exported contactgroups
  Nagios_contactgroup <<| |>> {
    mode   => '0644',
    target => '/etc/nagios3/conf.d/contactgroups.cfg',
    notify => Service['nagios3'],
  }
}
