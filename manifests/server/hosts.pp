class nagios::server::hosts {
  include ::nagios::params

  resources { 'nagios_host':
    purge => true,
  }

  # ensure the host config dir is present

  file { $nagios::params::host_conf_dir:
    ensure  => directory,
    require => Package['nagios3'],
  }

  # add a generic host others can inherit from

  @@nagios_host { 'generic-host':
    name                         => 'generic-host',
    check_command                => 'check-host-alive',
    contact_groups               => 'dev',

    event_handler_enabled        => 1,
    flap_detection_enabled       => 1,
    failure_prediction_enabled   => 1,
    process_perf_data            => 1,
    retain_status_information    => 1,
    retain_nonstatus_information => 1,
    max_check_attempts           => 10,

    notifications_enabled        => 1,
    notification_interval        => 0,
    notification_period          => '24x7',
    notification_options         => 'd,u,r',

    register                     => 0,
    use                          => undef,

    target => "${nagios::params::conf_dir}/generic-host.cfg",
  }

  # realize other host configuration

  Nagios_host <<| |>> {
    mode    => '0644',
    use     => 'generic-host',
    notify  => Service['nagios3'],
    require => [
      Package['nagios3'],
      File[$nagios::params::host_conf_dir],
    ],
  }

  # clean up deactivated hosts
  # (this is just a roundabout way of getting the list of deactivated nodes, necessary because the puppetdb API doesn't support that.)
  $active_nodes        = query_nodes( 'Nagios::Host' )
  $configured_nodes    = split( $::configured_nagios_hosts, ',' )
  $deactivated_nodes   = difference( $configured_nodes, $active_nodes )
  $deactivated_configs = prefix( suffix( $deactivated_nodes, ".cfg" ), "${nagios::params::host_conf_dir}/" )

  file { $deactivated_configs:
    ensure  => absent,
    notify  => Service['nagios3'],
    require => [
      Package['nagios3'],
      File[$nagios::params::host_conf_dir],
    ],
  }
}
