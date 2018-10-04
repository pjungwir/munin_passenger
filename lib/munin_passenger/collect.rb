require 'json'
require 'nokogiri'
require 'ostruct'

module MuninPassenger
  module Collect

    def self.default_state_file
      {
        'pses' => []
      }
    end

    def self.read_state_file
      filename = ENV['MUNIN_STATEFILE']
      if filename and File.exist?(filename)
        begin
          JSON.parse(File.open(filename, 'r') {|f| f.read})
        rescue
          $stderr.puts "WARN: Couldn't open munin statefile at #{filename}: #{$!.message}"
          default_state_file
        end
      else
        default_state_file
      end
    end

    def self.write_state_file(state)
      filename = ENV['MUNIN_STATEFILE']
      if filename
        begin
          File.open(filename, 'w') do |f|
            f.write state.to_json
          end
        rescue
          $stderr.puts "WARN: Error writing to statefile at #{filename}: #{$!.message}"
        end
      end
    end

    def self.parse_stats(f)
      Nokogiri::XML(f) do |config|
        config.strict.
               noblanks.  # Exclude blank nodes
               nonet      # Don't make any network connections
      end
    end

    def self.get_group_stats(doc)
      ret = []
      doc.xpath('//info/supergroups/supergroup').each do |x_supergroup|
        x_supergroup.xpath('./group').each do |x_group|
          g = OpenStruct.new
          g.name = x_group.xpath('name').first.text
          g.queue = x_group.xpath('get_wait_list_size').first.text
          ret << g
        end
      end
      ret
    end

    def self.get_ps_stats(doc)
      state = read_state_file
      slots_by_pid = {}
      state['pses'].each_with_index do |pid, i|
        slots_by_pid[pid] = i if pid
      end
      ret = [nil] * state['pses'].size  # Need at least as many workers as the most we've seen.
      curr_pses = []
      now = Time.now
      doc.xpath('//info/supergroups/supergroup').each do |x_supergroup|
        x_supergroup.xpath('./group').each do |x_group|
          x_group.xpath('./processes/process').each do |x_ps|
            pid = x_ps.xpath('pid').first.text
            ps = OpenStruct.new
            ps.active      = true
            ps.pid         = pid
            ps.sessions    = x_ps.xpath('sessions').first.text.to_i
            ps.last_used   = (now - Time.at(x_ps.xpath('last_used').first.text.to_i / 1000 / 1000).to_i).to_i # in seconds
            ps.ram         = x_ps.xpath('real_memory').first.text.to_i   # in KB
            ps.cpu         = x_ps.xpath('cpu').first.text.to_i           # in %
            ps.uptime      = (now - Time.at(x_ps.xpath('spawn_start_time').first.text.to_i / 1000 / 1000).to_i).to_i # in seconds
            ps.processed   = x_ps.xpath('processed').first.text.to_i     # in requests
            ps.last_seen   = now.to_i
            curr_pses << ps
          end
        end
      end
      # This is all a little tricky,
      # but if we name each metric after the pid,
      # munin will throw away the history when passenger is restarted and the pids change.
      # So instead we have "worker1", "worker2", etc.,
      # and we show the current pid in parentheses.
      # Each time we collect info, we keep a pid in the same slot as before.
      # If a pid goes away, we free that slot.
      # If it's the first we've seen a pid,
      # we give it the first free slot.
      new_pses = []
      curr_pses.each do |ps|
        i = slots_by_pid[ps.pid]
        if i
          ret[i] = ps
        else
          new_pses << ps
        end
      end
      new_pses.each do |ps|
        i = ret.index{|x| x == nil}
        if i
          ret[i] = ps
        else
          ret << ps
        end
      end
      state['pses'] = ret.map do |ps|
        if ps
          {
            'pid'       => ps.pid,
            'last_seen' => ps.last_seen,
          }
        else
          nil
        end
      end
      write_state_file(state)
      # Now if there are still nils,
      # it means we are running than fewer workers than before.
      # Preserve those slots,
      # but the graphing code will have to watch out
      # and note that they have no process currently.
      ret
    end

    def self.run_status
      dir = if ENV['PASSENGER_ROOT']
              "#{ENV['PASSENGER_ROOT']}/"
            else
              ''
            end

      sudo = if ENV['WITHOUT_SUDO']
               ''
             else
               'sudo '
             end

      status = `#{sudo}#{dir}passenger-status --show=xml`
      if not $?.success?
        $stderr.puts 'Error running passenger-status'
        exit 1
      end
      status
    end

  end
end
