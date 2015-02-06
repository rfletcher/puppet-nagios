Facter.add( :configured_nagios_hosts ) do
  setcode do
    dir = "/etc/nagios3/conf.d/hosts"

    Dir.glob( "#{dir}/*.cfg" ).map { |p|
      File.basename( p, ".cfg" )
    }.join( ',' )
  end
end
