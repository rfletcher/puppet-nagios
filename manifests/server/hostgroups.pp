class nagios::server::hostgroups {
  resources { 'nagios_hostgroup':
    purge => true,
  }
}
