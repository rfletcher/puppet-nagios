define nagios::nrpe::command(
  $ensure = present,
  $command,
) {
  include ::nagios::nrpe

  file { "/etc/nagios/nrpe.d/${name}.cfg":
    content => template( 'nagios/nrpe/command.cfg.erb' ),
    mode    => '0644',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }
}
