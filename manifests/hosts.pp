class nagios::hosts {
  Nagios_host {
    mode   => '0644',
    target => '/etc/nagios3/conf.d/hosts.cfg',
    use    => 'generic-host',
    notify => Service['nagios3'],
  }

  nagios_host { 'generic-host':
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
  }

  # collect exported hosts
  Nagios_host <<| |>> {
    mode   => '0644',
    target => '/etc/nagios3/conf.d/hosts.cfg',
    use    => 'generic-host',
    notify => Service['nagios3'],
  }
}
