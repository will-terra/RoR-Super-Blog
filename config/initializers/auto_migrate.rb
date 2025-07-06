if Rails.env.production?
  begin
    Rails.logger.info "🔍 Rodando migrations automaticamente em produção..."
    ActiveRecord::MigrationContext.new(
      ActiveRecord::Migrator.migrations_paths, ActiveRecord::SchemaMigration
    ).migrate
    Rails.logger.info "✅ Migrations executadas com sucesso!"
  rescue => e
    Rails.logger.error "❌ Erro ao rodar migrations: #{e.message}"
    raise e
  end
end