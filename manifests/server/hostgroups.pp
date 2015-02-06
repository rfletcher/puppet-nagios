class nagios::server::hostgroups {
  include ::nagios::params

  resources { 'nagios_hostgroup':
    purge => true,
  }

  Nagios_hostgroup <<| |>> {
    mode    => '0644',
    target  => "${nagios::params::conf_dir}/hostgroups.cfg",
    notify  => Service['nagios3'],
    require => Package['nagios3'],
  }
}
