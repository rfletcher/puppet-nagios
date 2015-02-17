class nagios::params {
  $root_dir           = '/etc/nagios3'
  $conf_dir           = "${root_dir}/conf.d"
  $host_conf_dir      = "${conf_dir}/hosts"
  $hostgroup_conf_dir = "${conf_dir}/hostgroups"
}
