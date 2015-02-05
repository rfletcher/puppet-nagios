define nagios::command(
  $ensure = present,
  $command_line,
) {
  @@nagios_command { $name:
    ensure       => $ensure,
    command_line => $command,
    target       => $target,
  }
}
