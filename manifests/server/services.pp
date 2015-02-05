class nagios::server::services {
  resources { 'nagios_service':
    purge => true,
  }

  @@nagios_service { 'generic-service':
    name                         => 'generic-service',

    contact_groups               => 'dev',
    check_period                 => '24x7',

    active_checks_enabled        => 1,
    passive_checks_enabled       => 1,
    parallelize_check            => 1,
    obsess_over_service          => 1,
    check_freshness              => 0,
    event_handler_enabled        => 1,
    flap_detection_enabled       => 1,
    failure_prediction_enabled   => 1,
    process_perf_data            => 1,
    retain_status_information    => 1,
    retain_nonstatus_information => 1,
    is_volatile                  => 0,
    normal_check_interval        => 5,
    retry_check_interval         => 1,
    max_check_attempts           => 4,

    notifications_enabled        => 1,
    notification_interval        => 0,
    notification_period          => '24x7',
    notification_options         => 'w,u,c,r',

    register                     => 0,
    use                          => undef,
  }

  @@nagios_service { 'check-all-disks':
    hostgroup_name      => 'all',
    check_command       => 'check_nrpe_with_timeout!30!check_all_disks!10% 5%',
    service_description => 'Disk Space',
    use                 => 'generic-service',
  }

  # collect exported services
  Nagios_service <<| |>> {
    mode   => '0644',
    target => '/etc/nagios3/conf.d/services.cfg',
    use    => 'generic-service',
    notify => Service['nagios3'],
  }
}
