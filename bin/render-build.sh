#!/usr/bin/env bash

# Exit on error
set -o errexit

echo "🔍 Starting build process..."
echo "🔍 Environment variables check:"
echo "DATABASE_URL: ${DATABASE_URL:-'NOT SET'}"
echo "RAILS_ENV: ${RAILS_ENV:-'NOT SET'}"
echo "ROR_SUPER_BLOG_DATABASE_PASSWORD: ${ROR_SUPER_BLOG_DATABASE_PASSWORD:-'NOT SET'}"

echo "🔍 All environment variables containing 'DATA', 'DB', or 'POSTGRES':"
env | grep -E -i '(data|db|postgres)' || echo "No relevant database environment variables found"

echo "🔍 PostgreSQL related processes:"
ps aux | grep -i postgres || echo "No PostgreSQL processes found"

bundle install
bin/rails assets:precompile
bin/rails assets:clean

echo "🔍 About to run database migration..."
echo "🔍 Checking database connection..."

# Check if we can connect to the database
if [ -n "$DATABASE_URL" ]; then
    echo "🔍 DATABASE_URL is set, attempting connection test..."
    echo "🔍 DATABASE_URL (first 50 chars): ${DATABASE_URL:0:50}..."
    
    # Try a simple database connection test
    bundle exec rails runner "
      begin
        puts '🔍 Testing database connection...'
        connection = ActiveRecord::Base.connection
        result = connection.execute('SELECT version()')
        puts '✅ Database connection successful!'
        puts '🔍 PostgreSQL version: ' + result.first['version'].split(' ')[0..2].join(' ')
        
        puts '🔍 Database configuration:'
        config = ActiveRecord::Base.connection_config
        puts '  Adapter: ' + config[:adapter].to_s
        puts '  Database: ' + config[:database].to_s
        puts '  Host: ' + config[:host].to_s
        puts '  Port: ' + config[:port].to_s
        puts '  Username: ' + config[:username].to_s
      rescue => e
        puts '❌ Database connection failed!'
        puts '❌ Error: ' + e.message
        puts '❌ Error class: ' + e.class.to_s
        puts '❌ Backtrace:'
        puts e.backtrace.first(10).join(\"\n\")
        exit 1
      end
    " || { echo "❌ Database connection test failed"; exit 1; }
else
    echo "⚠️  DATABASE_URL is not set, this might cause connection issues"
    echo "🔍 Available environment variables containing 'DATA':"
    env | grep -i data || echo "No DATABASE related environment variables found"
fi

# If you have a paid instance type, we recommend moving
# database migrations like this one from the build command
# to the pre-deploy command:
