define nagios::service(
  $command = false,
  $group   = $name,
) {
  $real_group = $group ? {
    false   => $name,
    default => $group,
  }

  if $real_group =~ /(disk|interfaces|smart)/ {
    $real_command = "${command}${name}"
  } else {
    $real_command = $command
  }

  @@nagios_service { "${::hostname}_${name}":
    ensure              => present,
    check_command       => $real_command,
    host_name           => $::hostname,
    servicegroups       => $real_group,
    service_description => $name,
    use                 => 'generic-service',
    target              => "/etc/nagios3/conf.d/${::hostname}_services.cfg",
  }
}
