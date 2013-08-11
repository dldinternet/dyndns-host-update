#!/usr/bin/env ruby
#-*- coding: utf-8 -*-

# Find and update IP using simple query to DYNDNS.org
#
#* required yaml format
=begin
global:
  ip: 127.0.0.1
site:
  myhost: example.com
  id: hoge
  pass: foobar
=end
module DynDNSHostUpdate
  require 'open-uri'
  require 'yaml'
  require 'resolv'
  require 'logger'

  class NotFoundError < StandardError ; end

  class Main < Logger::Application
    attr_accessor :options

    def initialize(options)
      @options = options
      super('DynDNSHostUpdate') # Name of the application.
      if File.directory?(File.dirname(@options[:logfile]))
        date = Time.now.strftime("%Y%m%d")
        set_log(@options[:logfile].sub /\.log/, "#{date}.log")
      else
        log(ERROR,"No such directory, cannot log there: #{File.dirname(@options[:logfile])}")
      end
    end

    def run

      # Get IP Address
      now_ip = nil
      open('http://checkip.dyndns.org/.') { |f|
        f.read =~ /((\d{1,3}\.){3}\d{1,3})/
        now_ip = $1
      }
      begin
        myinfo = YAML.load_file(@options[:yamlfile])
      rescue => e
        log(ERROR, "ERROR: #{e.message}")
        raise e
      end
      my_ip = Resolv.getaddress(myinfo['site']['myhost'])

      saved_ip = myinfo['global']['ip']
      if now_ip == saved_ip and my_ip == saved_ip
        log(INFO, "no ip change: #{now_ip}")
        #myinfo['global']['ip'] = my_ip
        #File.open(@options[:yamlfile], 'w') { |f|
        #  f.puts YAML.dump(myinfo)
        #}
        0
      else
        # Update dyndns.org
        myinfo['global']['ip'] = my_ip
        myhost = myinfo['site']['myhost']
        id = myinfo['site']['id']
        pass = myinfo['site']['pass']
        ua = "#{myhost} - Ruby/#{RUBY_VERSION} - 0.01"

        options = {:http_basic_authentication => [id, pass],
                   "User-Agent" => ua}
        params = "hostname=#{myhost}&myip=#{now_ip}"
        res = []
        open("http://members.dyndns.org/nic/update?#{params}", options) { |f|
          res << f.read
        }
        log(INFO, "#{myhost}: "+res.join("\n"))
        ok = false
        res.each { |l| ok = l.to_s.match(/(success|nochg)/) { |m| true } }
        if ok
          # Update YAML File
          File.open(@options[:yamlfile], 'w') { |f|
            f.puts YAML.dump(myinfo)
          }
          0
        else
          log(ERROR, "IP not updated. Bad response: #{res.join(' - ')}")
          1
        end
      end

    end

  end

end
