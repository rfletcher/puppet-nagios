class nagios::hostgroups {
  Nagios_hostgroup {
    mode   => '0644',
    target => '/etc/nagios3/conf.d/hostgroups.cfg',
    notify => Service['nagios3'],
  }

  nagios_hostgroup { 'all':
    alias   => 'All Servers',
    members => '*',
  }

  # collect exported hostgroups
  Nagios_hostgroup <<| |>> {
    mode   => '0644',
    target => '/etc/nagios3/conf.d/hostgroups.cfg',
    notify => Service['nagios3'],
  }
}
