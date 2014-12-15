class nagios(
  $contacts       = undef,
  $contact_groups = undef,
  $htpasswd       = undef,
) {
  include ::nagios::nrpe
}
