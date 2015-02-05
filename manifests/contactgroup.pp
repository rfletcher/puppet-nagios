define nagios::contactgroup(
  $ensure  = present,
  $members = undef,
) {
  @@nagios_contactgroup { $name:
    ensure  => $ensure,
    members => is_array( $members ) ? { true => join( $members, ',' ), false => $members },
  }
}
