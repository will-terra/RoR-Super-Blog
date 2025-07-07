# Database connection logging for debugging
Rails.application.configure do
  config.after_initialize do
    if Rails.env.production?
      Rails.logger.info "🔍 Database Configuration Debug:"
      Rails.logger.info "  DATABASE_URL present: #{ENV['DATABASE_URL'].present?}"
      Rails.logger.info "  DATABASE_URL (masked): #{ENV['DATABASE_URL']&.gsub(/:[^:@]*@/, ':***@')}"
      Rails.logger.info "  ROR_SUPER_BLOG_DATABASE_PASSWORD present: #{ENV['ROR_SUPER_BLOG_DATABASE_PASSWORD'].present?}"
      # Removido debug de ActiveRecord::Base.connection_config pois não existe mais no Rails 8
    end
  end
end
