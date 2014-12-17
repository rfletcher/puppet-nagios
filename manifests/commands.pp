class nagios::commands {
  Nagios_command {
    mode   => '0644',
    target => '/etc/nagios3/conf.d/commands.cfg',
    notify => Service['nagios3'],
  }

  nagios_command { 'check_nrpe_with_timeout':
    command_line => '/usr/lib/nagios/plugins/check_nrpe -H $HOSTADDRESS$ -t $ARG1$ -c $ARG2$ -a $ARG3$'
  }

  # collect exported hosts
  Nagios_command <<| |>> {
    mode   => '0644',
    target => '/etc/nagios3/conf.d/commands.cfg',
    notify => Service['nagios3'],
  }
}
