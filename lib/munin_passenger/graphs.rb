module MuninPassenger
  module Graphs

    def self.escape_group(g_name)
      g_name.gsub(/^[^a-zA-Z_]/, '_').
        gsub(/[^a-zA-Z0-9_]/, '_')
    end

    def self.get_stats
      doc = MuninPassenger::Collect.parse_stats(MuninPassenger::Collect.run_status)
      groups = MuninPassenger::Collect.get_group_stats(doc)
      pses = MuninPassenger::Collect.get_ps_stats(doc)
      [groups, pses]
    end

    # ###############
    # passenger_queue
    # ###############

    def self.queue_config
      groups, pses = get_stats
      ret = ''
      ret += <<-EOF
graph_category passenger
graph_title Passenger queue
graph_vlabel Requests
      EOF
      groups.each do |g|
        ret += <<-EOF
_group_#{escape_group(g.name)}_queue.label #{g.name}
        EOF
      end
      pses.each do |ps|
        ret += <<-EOF
_pid_#{ps.pid}_sessions.label PID #{ps.pid}
        EOF
      end
      ret
    end

    def self.queue_values
      groups, pses = get_stats
      ret = ''
      groups.each do |g|
        ret += <<-EOF
_group_#{escape_group(g.name)}_queue.value #{g.queue}
    EOF
      end
      pses.each do |ps|
        ret += <<-EOF
_pid_#{ps.pid}_sessions.value #{ps.sessions}
        EOF
      end
      ret
    end

    # #############
    # passenger_ram
    # #############

    def self.ram_config
      groups, pses = get_stats
      ret = ''
      ret += <<-EOF
graph_category passenger
graph_title Passenger memory usage
graph_vlabel Bytes
      EOF
      pses.each do |ps|
        ret += <<-EOF
_pid_#{ps.pid}_ram.label PID #{ps.pid}
        EOF
      end
      ret
    end

    def self.ram_values
      groups, pses = get_stats
      ret = ''
      pses.each do |ps|
        ret += <<-EOF
_pid_#{ps.pid}_ram.value #{ps.ram * 1024}
        EOF
      end
      ret
    end

    # #############
    # passenger_cpu
    # #############

    def self.cpu_config
      groups, pses = get_stats
      ret = ''
      ret += <<-EOF
graph_category passenger
graph_title Passenger CPU
graph_vlabel %
      EOF
      pses.each do |ps|
        ret += <<-EOF
_pid_#{ps.pid}_cpu.label PID #{ps.pid}
        EOF
      end
      ret
    end

    def self.cpu_values
      groups, pses = get_stats
      ret = ''
      pses.each do |ps|
        ret += <<-EOF
_pid_#{ps.pid}_cpu.value #{ps.cpu}
        EOF
      end
      ret
    end

    # ###################
    # passenger_processed
    # ###################

    def self.processed_config
      groups, pses = get_stats
      ret = ''
      ret += <<-EOF
graph_category passenger
graph_title Requests processed
graph_vlabel Requests
      EOF
      pses.each do |ps|
        ret += <<-EOF
_pid_#{ps.pid}_processed.label PID #{ps.pid}
        EOF
      end
      ret
    end

    def self.processed_values
      groups, pses = get_stats
      ret = ''
      pses.each do |ps|
        ret += <<-EOF
_pid_#{ps.pid}_processed.value #{ps.processed}
        EOF
      end
      ret
    end

    # ################
    # passenger_uptime
    # ################

    def self.uptime_config
      groups, pses = get_stats
      ret = ''
      ret += <<-EOF
graph_category passenger
graph_title Uptime
graph_vlabel Hours
      EOF
      pses.each do |ps|
        ret += <<-EOF
_pid_#{ps.pid}_uptime.label PID #{ps.pid}
        EOF
      end
      ret
    end

    def self.uptime_values
      groups, pses = get_stats
      ret = ''
      pses.each do |ps|
        ret += <<-EOF
_pid_#{ps.pid}_uptime.value #{ps.uptime.to_f / 60 / 60}
        EOF
      end
      ret
    end

    # ###################
    # passenger_last_used
    # ###################

    def self.last_used_config
      groups, pses = get_stats
      ret = ''
      ret += <<-EOF
graph_category passenger
graph_title Last used
graph_vlabel Seconds
      EOF
      pses.each do |ps|
        ret += <<-EOF
_pid_#{ps.pid}_last_used.label PID #{ps.pid}
        EOF
      end
      ret
    end

    def self.last_used_values
      groups, pses = get_stats
      ret = ''
      pses.each do |ps|
        ret += <<-EOF
_pid_#{ps.pid}_last_used.value #{ps.last_used}
        EOF
      end
      ret
    end

  end
end
