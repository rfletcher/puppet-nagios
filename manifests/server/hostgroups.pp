class nagios::server::hostgroups {
  include ::nagios::params

  resources { 'nagios_hostgroup':
    purge => true,
  }

  # ensure the host config dir is present

  file { $nagios::params::hostgroup_conf_dir:
    ensure  => directory,
    require => Package['nagios3'],
  }

  Nagios_hostgroup <<| |>> {
    mode    => '0644',
    notify  => Service['nagios3'],
    require => [
      Package['nagios3'],
      File[$nagios::params::hostgroup_conf_dir],
    ],
  }

  # clean up deactivated hostgroups
  # (this is just a roundabout way of getting the list of deactivated nodes, necessary because the puppetdb API doesn't support that.)
  $active_hostgroups      = nagios_hostgroups( true )
  $configured_hostgroups  = split( $::configured_nagios_hostgroups, ',' )
  $deactivated_hostgroups = difference( $configured_hostgroups, $active_hostgroups )
  $deactivated_configs    = prefix( suffix( $deactivated_hostgroups, ".cfg" ), "${nagios::params::hostgroup_conf_dir}/" )

  file { $deactivated_configs:
    ensure  => absent,
    notify  => Service['nagios3'],
    require => [
      Package['nagios3'],
      File[$nagios::params::hostgroup_conf_dir],
    ],
  }
}
