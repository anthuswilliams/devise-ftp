#!/usr/bin/env ruby
require 'rubygems'
require 'bcrypt'
require 'mysql2'
require 'yaml'

RAILS_ROOT = File.expand_path(File.dirname(__FILE__))

UID = 501
GID = 20

config = YAML.load(IO.read("#{RAILS_ROOT}/config/database.yml"))['development']
u = {}

begin
    dbh = Mysql2::Client.new(:username => config['username'], :password => config['password'], :socket => config['socket'], :database => config['database']) 
    dbh.query("SELECT * FROM users WHERE email = '#{ENV['AUTHD_ACCOUNT'].gsub(/'/,"''")}' LIMIT 1").each do |r|
        u = r
    end
rescue Mysql2::Error => e
ensure
    dbh.close if dbh
end

if u['encrypted_password'].nil?
    # no such user
    puts "auth_ok:0"
else
    #validate pw
    # note this assumes we are using the default bcrypt used by the devise gem, i.e. we have no pepper string
    # if we seed with a pepper string (defined in config/initializers/devise.rb) this script will need to be changed
    if BCrypt::Password::new(u['encrypted_password']) != ENV['AUTHD_PASSWORD']
        puts "auth_ok:0"
    else
        puts "auth_ok:1"
        puts "uid:#{UID}"
        puts "gid:#{GID}"
        puts "dir:#{RAILS_ROOT}/public/system/templates/#{u['template_dir']}"
    end
end

puts "end"
