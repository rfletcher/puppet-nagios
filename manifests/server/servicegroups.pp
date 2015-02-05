class nagios::server::servicegroups {
  resources { 'nagios_servicegroup':
    purge => true,
  }
}
