define nagios::command(
  $ensure = present,
  $command,
  $target = undef,
) {
  $real_target = $target ? {
    undef   => "/etc/nagios3/conf.d/command-${name}",
    default => $target,
  }

  nagios_command { $name:
    ensure       => $ensure,
    command_line => $command,
    target       => $real_target,
  }
}
