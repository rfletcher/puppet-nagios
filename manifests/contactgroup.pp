define nagios::contactgroup(
  $ensure  = present,
  $members = undef,
) {
  $real_members = is_array( $members ) ? {
    true  => join( $members, ',' ),
    false => $members,
  }

  @@nagios_contactgroup { $name:
    ensure  => $ensure,
    members => $real_members,
  }
}
