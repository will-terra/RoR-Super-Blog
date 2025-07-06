# Database connection logging for debugging
Rails.application.configure do
  config.after_initialize do
    if Rails.env.production?
      Rails.logger.info "🔍 Database Configuration Debug:"
      Rails.logger.info "  DATABASE_URL present: #{ENV['DATABASE_URL'].present?}"
      Rails.logger.info "  DATABASE_URL (masked): #{ENV['DATABASE_URL']&.gsub(/:[^:@]*@/, ':***@')}"
      Rails.logger.info "  ROR_SUPER_BLOG_DATABASE_PASSWORD present: #{ENV['ROR_SUPER_BLOG_DATABASE_PASSWORD'].present?}"
      
      begin
        # config = ActiveRecord::Base.connection_config
        Rails.logger.info "  ActiveRecord config adapter: #{ActiveRecord::Base.connection_config[:adapter]}"
        Rails.logger.info "  ActiveRecord config database: #{ActiveRecord::Base.connection_config[:database]}"
        Rails.logger.info "  ActiveRecord config host: #{ActiveRecord::Base.connection_config[:host]}"
        Rails.logger.info "  ActiveRecord config port: #{ActiveRecord::Base.connection_config[:port]}"
        Rails.logger.info "  ActiveRecord config username: #{ActiveRecord::Base.connection_config[:username]}"
      rescue => e
        Rails.logger.error "❌ Error getting database config: #{e.message}"
      end
    end
  end
end
