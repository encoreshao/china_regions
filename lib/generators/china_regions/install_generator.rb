# frozen_string_literal: true

module ChinaRegions
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('templates', __dir__)

    def copy_migration
      Dir['db/migrate/*_china_regions_tables.rb'].each { |file| File.delete(file) }

      migration_template 'migration.rb', 'db/migrate/create_china_regions_tables.rb'
    end

    def copy_locales
      %w[en zh].each do |locale|
        config_file = "config/locales/regions.#{locale}.yml"
        copy_file "../../../../config/locales/china_regions.#{locale}.yml", config_file unless File.exist?(config_file)
      end
    end

    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        Time.now.utc.strftime('%Y%m%d%H%M%S')
      else
        format('%.3d', current_migration_number(dirname) + 1)
      end
    end

    def migration_version
      "#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"
    end
  end
end
