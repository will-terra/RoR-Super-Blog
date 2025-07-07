namespace :db do
  task migrate: :environment do
    puts "🔍 Starting database migration process..."
    puts "🔍 Rails environment: #{Rails.env}"

    begin
      puts "🔍 Testing database connection..."
      ActiveRecord::Base.connection.execute("SELECT 1")
      puts "✅ Database connection successful"
    rescue => e
      puts "❌ Database connection failed: #{e.message}"
      puts "❌ Error class: #{e.class}"
      puts "❌ Backtrace:"
      puts e.backtrace.first(5).join("\n")

      # Try to get more info about the connection
      begin
        # config = ActiveRecord::Base.connection_config
        puts "🔍 Connection config: #{config.inspect}"
      rescue => config_error
        puts "❌ Could not get connection config: #{config_error.message}"
      end

      raise e
    end
  end
end
