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
        format('%.3d', (current_migration_number(dirname) + 1))
      end
    end

    def add_rails_version_for_migration
      rails_version = Gem.loaded_specs["activesupport"].version
      return if rails_version < Gem::Version.create('4.0')

      migration_version = rails_version.to_s.split(/\./)[0..1].join('.')
      filename  = 'db/migrate/*create_china_regions_tables.rb'
      kclass    = 'ActiveRecord::Migration'

      system(`grep -rl "#{kclass}$" #{filename} | xargs sed -i "" "s/#{kclass}/#{kclass}[#{migration_version}]/g"`)
    end
  end
end
