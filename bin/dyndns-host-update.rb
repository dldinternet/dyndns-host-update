#!/usr/bin/env ruby
$:.unshift(File.dirname(__FILE__) + '/../lib') unless $:.include?(File.dirname(__FILE__) + '/../lib')

require 'optparse'

PWD = File::dirname(__FILE__)
YAMLFILE = File.join(PWD, 'dyndns.yaml')
LOGFILE = File.join(PWD, 'log', 'dyndns.log')


options = {
    :yamlfile => YAMLFILE,
    :logfile => LOGFILE,
}
opts = OptionParser.new do |opts|
  opts.banner = "Usage: dyndns-host-update.rb [options]"

  opts.on("-l", "--logfile LOG", "Log file") do |v|
    options[:logfile] = v
  end

  opts.on("-y", "--yamlfile YAML", "YAML Config file") do |v|
    options[:yamlfile] = v
  end

  opts.on("-v", "--verbose LEVEL", "Run verbosely") do |v|
    options[:verbose] = v
  end
end
opts.parse!

require 'dyndns-host-update'

status = DynDNSHostUpdate::Main.new(options).start
