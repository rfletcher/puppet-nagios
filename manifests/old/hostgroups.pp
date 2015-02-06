class nagios::hostgroups {
  include ::nagios::params

  @@nagios_hostgroup { 'all':
    alias   => 'All Servers',
    members => '*',
  }

  # collect exported hostgroups
  Nagios_hostgroup <<| |>> {
    mode   => '0644',
    target => "${nagios::params::conf_dir}/hostgroups.cfg",
    notify => Service['nagios3'],
  }
}
