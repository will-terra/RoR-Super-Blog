#!/usr/bin/env ruby

puts "🔍 " + "="*50
puts "🔍 DATABASE DIAGNOSTIC SCRIPT"
puts "🔍 " + "="*50

puts "\n🔍 ENVIRONMENT INFORMATION:"
puts "  Ruby version: #{RUBY_VERSION}"
puts "  Rails environment: #{ENV['RAILS_ENV'] || 'NOT SET'}"
puts "  Current directory: #{Dir.pwd}"

puts "\n🔍 DATABASE ENVIRONMENT VARIABLES:"
ENV.each do |key, value|
  if key.match?(/database|db|postgres|pg/i)
    # Mask sensitive information
    display_value = key.downcase.include?('password') ? '[MASKED]' : value
    puts "  #{key}: #{display_value}"
  end
end

puts "\n🔍 DATABASE_URL ANALYSIS:"
if ENV['DATABASE_URL']
  begin
    require 'uri'
    uri = URI.parse(ENV['DATABASE_URL'])
    puts "  Protocol: #{uri.scheme}"
    puts "  Host: #{uri.host}"
    puts "  Port: #{uri.port}"
    puts "  Database: #{uri.path&.gsub('/', '')}"
    puts "  Username: #{uri.user}"
    puts "  Password: #{uri.password ? '[PRESENT]' : '[NOT SET]'}"
  rescue => e
    puts "  Error parsing DATABASE_URL: #{e.message}"
  end
else
  puts "  DATABASE_URL is not set"
end

puts "\n🔍 GEMFILE.LOCK DATABASE GEMS:"
if File.exist?('Gemfile.lock')
  lockfile = File.read('Gemfile.lock')
  db_gems = lockfile.scan(/^\s+(pg|sqlite|mysql|activerecord).*$/)
  db_gems.each { |gem| puts "  #{gem.first}" }
else
  puts "  Gemfile.lock not found"
end

puts "\n🔍 ATTEMPTING RAILS LOAD:"
begin
  require_relative '../config/environment'
  puts "  ✅ Rails loaded successfully"
  
  puts "\n🔍 ACTIVERECORD CONNECTION CONFIG:"
  config = ActiveRecord::Base.connection_config
  config.each do |key, value|
    display_value = key.to_s.downcase.include?('password') ? '[MASKED]' : value
    puts "  #{key}: #{display_value}"
  end
  
  puts "\n🔍 TESTING DATABASE CONNECTION:"
  result = ActiveRecord::Base.connection.execute("SELECT version()")
  puts "  ✅ Connection successful!"
  puts "  PostgreSQL version: #{result.first['version']}"
  
rescue => e
  puts "  ❌ Error: #{e.message}"
  puts "  ❌ Error class: #{e.class}"
  puts "  ❌ Backtrace (first 10 lines):"
  e.backtrace.first(10).each { |line| puts "    #{line}" }
end

puts "\n🔍 " + "="*50
puts "🔍 END OF DIAGNOSTIC"
puts "🔍 " + "="*50
