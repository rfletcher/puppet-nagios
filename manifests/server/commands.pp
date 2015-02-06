class nagios::server::commands {
  include ::nagios::params

  resources { 'nagios_command':
    purge => true,
  }

  @@nagios_command { 'check_nrpe_with_timeout':
    command_line => '/usr/lib/nagios/plugins/check_nrpe -H $HOSTADDRESS$ -t $ARG1$ -c $ARG2$ -a $ARG3$'
  }

  Nagios_command <<| |>> {
    mode    => '0644',
    target  => "${nagios::params::conf_dir}/commands.cfg",
    notify  => Service['nagios3'],
    require => Package['nagios3'],
  }
}
