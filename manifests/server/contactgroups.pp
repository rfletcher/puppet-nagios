class nagios::server::contactgroups {
  include ::nagios::params

  resources { 'nagios_contactgroup':
    purge => true,
  }

  Nagios_contactgroup <<| |>> {
    mode    => '0644',
    target  => "${nagios::params::conf_dir}/contactgroups.cfg",
    notify  => Service['nagios3'],
    require => Package['nagios3'],
  }
}
