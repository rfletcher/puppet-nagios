define nagios::plugin(
  $ensure  = present,
  $source  = undef,
  $content = undef,
) {
  include ::nagios

  file { "/usr/lib/nagios/plugins/${title}":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    group   => 'root',
    mode    => '0755',
    owner   => 'root',
    require => Class['::nagios'],
  }
}
