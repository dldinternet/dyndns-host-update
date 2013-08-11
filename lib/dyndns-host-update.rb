#!/usr/bin/env ruby
#-*- coding: utf-8 -*-

# Find and update IP using simple query to DYNDNS.org
#
#* required yaml format
#=begin
#global:
# ip: 127.0.0.1
# site:
# myhost: example.com
# id: hoge
# pass: foobar
#=end

require 'open-uri'
require 'yaml'
require 'resolv'

PWD = File::dirname(__FILE__)
YAMLFILE = File.join(PWD, 'ddns.yml')
LOGFILE = File.join(PWD, 'log', 'ddns.log')

def logging str
  date = Time.now.strftime("%Y%m")
  path = LOGFILE.sub /\.log/, "#{date}.log"
  File.open(path, 'a'){|f| f.puts "[#{Time.now}] #{str}"}
end

# Get IP Address
now_ip = nil
open('http://checkip.dyndns.org/.') { |f|
  f.read =~ /((\d{1,3}\.){3}\d{1,3})/
  now_ip = $1
}

my_ip = Resolv.getaddress(config['host'])

myinfo = YAML.load_file(YAMLFILE)
saved_ip = myinfo['global']['ip']
if now_ip == saved_ip and my_ip == saved_ip
  logging "no ip change: #{now_ip}"
  exit 0
end

# Update dyndns.org
myinfo['global']['ip'] = now_ip
myhost = myinfo['site']['myhost']
id = myinfo['site']['id']
pass = myinfo['site']['pass']
ua = "#{myhost} - Ruby/#{RUBY_VERSION} - 0.01"

options = {:http_basic_authentication=>[id,pass],
           "User-Agent"=>ua}
params = "hostname=#{myhost}&myip=#{now_ip}"
open("http://members.dyndns.org/nic/update?#{params}", options) {|f|
  logging "#{myhost}: "+ f.read
}

# Update YAML File
File.open(YAMLFILE, 'w'){|f|
  f.puts YAML.dump(myinfo)
}