class nagios::server::timeperiods {
  resources { 'nagios_timeperiod':
    purge => true,
  }

  @@nagios_timeperiod { '24x7':
    alias     => '24 Hours A Day, 7 Days A Week',
    sunday    => '00:00-24:00',
    monday    => '00:00-24:00',
    tuesday   => '00:00-24:00',
    wednesday => '00:00-24:00',
    thursday  => '00:00-24:00',
    friday    => '00:00-24:00',
    saturday  => '00:00-24:00',
  }

  # Here is a slightly friendlier period during work hours
  @@nagios_timeperiod{ 'workhours':
    alias     => 'Typical Engineering Work Hours',
    monday    => '10:00-18:00',
    tuesday   => '10:00-18:00',
    wednesday => '10:00-18:00',
    thursday  => '10:00-18:00',
    friday    => '10:00-18:00',
  }

  # The complement of workhours
  @@nagios_timeperiod{ 'nonworkhours':
     alias     => 'Non-Work Hours',
     sunday    => '00:00-24:00',
     monday    => '00:00-10:00,18:00-24:00',
     tuesday   => '00:00-10:00,18:00-24:00',
     wednesday => '00:00-10:00,18:00-24:00',
     thursday  => '00:00-10:00,18:00-24:00',
     friday    => '00:00-10:00,18:00-24:00',
     saturday  => '00:00-24:00',
  }

  # This one is a favorite: never :)
  @@nagios_timeperiod { 'never':
    alias => 'Never',
  }

  Nagios_timeperiod <<| |>> {
    mode    => '0644',
    target  => '/etc/nagios3/conf.d/timeperiods.cfg',
    notify  => Service['nagios3'],
    require => Package['nagios3'],
  }
}
