require 'nokogiri'
require 'ostruct'

module MuninPassenger
  module Collect

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
      ret = []
      now = Time.now
      doc.xpath('//info/supergroups/supergroup').each do |x_supergroup|
        x_supergroup.xpath('./group').each do |x_group|
          x_group.xpath('./processes/process').each do |x_ps|
            ps = OpenStruct.new
            ps.pid         = x_ps.xpath('pid').first.text
            ps.sessions    = x_ps.xpath('sessions').first.text.to_i
            ps.last_used   = (now - Time.at(x_ps.xpath('last_used').first.text.to_i / 1000 / 1000).to_i).to_i # in seconds
            ps.ram         = x_ps.xpath('real_memory').first.text.to_i   # in KB
            ps.cpu         = x_ps.xpath('cpu').first.text.to_i           # in %
            ps.uptime      = (now - Time.at(x_ps.xpath('spawn_start_time').first.text.to_i / 1000 / 1000).to_i).to_i # in seconds
            ps.processed   = x_ps.xpath('processed').first.text.to_i     # in requests
            ret << ps
          end
        end
      end
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
