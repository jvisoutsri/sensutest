#! /usr/bin/env ruby
#  encoding: UTF-8
#
#   disk-capacity-metrics
#
# DESCRIPTION:
#   This plugin uses df to collect disk capacity metrics
#   disk-metrics.rb looks at /proc/stat which doesnt hold capacity metricss.
#   could have intetrated this into disk-metrics.rb, but thought I'd leave it up to
#   whomever implements the checks.
#
# OUTPUT:
#   metric data
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: socket
#
# USAGE:
#
# NOTES:
#
# LICENSE:
#   Copyright 2012 Sonian, Inc <chefs@sonian.net>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require '/var/lib/gems/2.5.0/gems/sensu-plugin-4.0.0/lib/sensu-plugin/metric/cli'
require 'socket'

class DiskCapacity < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to .$parent.$child',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.disk"

  def convert_integers(values)
    values.each_with_index do |value, index|
      begin
        converted = Integer(value)
        values[index] = converted
        # #YELLOW
      rescue ArgumentError # rubocop:disable HandleExceptions
      end
    end
    values
  end

  def run
    # Get capacity metrics from DF as they don't appear in /proc
    `df -PT`.split("\n").drop(1).each do |line|
      begin
        fs, _type, _blocks, used, avail, capacity, _mnt = line.split

        timestamp = Time.now.to_i
        if fs.match('/dev')
          fs = fs.gsub('/dev/', '')
          metrics = {
            disk: {
              "#{fs}.used" => used,
              "#{fs}.avail" => avail,
              "#{fs}.capacity" => capacity.gsub('%', '')
            }
          }
          metrics.each do |parent, children|
            children.each do |child, value|
              output [config[:scheme], parent, child].join('.'), value, timestamp
            end
          end
        end
      rescue
        unknown "malformed line from df: #{line}"
      end
    end

    # Get inode capacity metrics
    `df -Pi`.split("\n").drop(1).each do |line|
      begin
        fs, _inodes, used, avail, capacity, _mnt = line.split

        timestamp = Time.now.to_i
        if fs.match('/dev')
          fs = fs.gsub('/dev/', '')
          metrics = {
            disk: {
              "#{fs}.iused" => used,
              "#{fs}.iavail" => avail,
              "#{fs}.icapacity" => capacity.gsub('%', '')
            }
          }
          metrics.each do |parent, children|
            children.each do |child, value|
              output [config[:scheme], parent, child].join('.'), value, timestamp
            end
          end
        end
      rescue
        unknown "malformed line from df: #{line}"
      end
    end
    ok
  end
end
