#!/usr/bin/env ruby

plugins = %w[queue ram cpu processed uptime last_used]

plugins.each do |g|
  filename = "bin/passenger_#{g}"
  File.open(filename, 'w') do |f|
    f.puts <<~EOF
      #!/usr/bin/env ruby

      require 'munin_passenger'

      if ARGV[0] == 'config'
        puts MuninPassenger::Graphs.#{g}_config
      else
        puts MuninPassenger::Graphs.#{g}_values
      end
    EOF
  end
  system("chmod +x #{filename}")
end

filename = "bin/munin_passenger-install.sh"
File.open(filename, 'w') do |f|
  f.puts <<~EOF
    #/bin/bash

    set -eu

    dest="${1:-/etc/munin/plugins/}"
    mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

  EOF
  plugins.each do |p|
    f.puts %Q{ln -fs "${mydir}/passenger_#{p}" "$dest"}
  end
end
system("chmod +x #{filename}")
