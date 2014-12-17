class nagios::contacts {
  Nagios_contact {
    mode   => '0644',
    target => '/etc/nagios3/conf.d/contacts.cfg',
    use    => 'generic-contact',
    notify => Service['nagios3'],
  }

  Nagios_contactgroup {
    mode   => '0644',
    target => '/etc/nagios3/conf.d/contactgroups.cfg',
    notify => Service['nagios3'],
  }

  nagios_contact { 'generic-contact':
    alias                           => 'generic-contact',

    email                           => 'root@localhost',

    host_notification_period        => '24x7',
    host_notification_options       => 'd,r',
    host_notification_commands      => 'notify-host-by-email',

    service_notification_period     => '24x7',
    service_notification_options    => 'w,u,c,r',
    service_notification_commands   => 'notify-service-by-email',

    register                        => 0,
    use                             => undef,
  }
}
