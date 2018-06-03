# frozen_string_literal: true

module ChinaRegions
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('templates', __dir__)

    def copy_migration
      Dir['db/migrate/*_china_regions_tables.rb'].each { |file| File.delete(file) }

      migration_template 'migration.rb', 'db/migrate/create_china_regions_tables.rb'
    end

    def copy_cities
      copy_file('cities.yml', 'config/cities.yml') unless File.exist?('config/cities.yml')
    end

    def copy_locales
      copy_file '../../../../config/locales/en.yml', 'config/locales/regions.en.yml' unless File.exist?('config/locales/regions.en.yml')
      copy_file '../../../../config/locales/zh.yml', 'config/locales/regions.zh.yml' unless File.exist?('config/locales/regions.zh.yml')
    end

    def copy_rake_tasks
      copy_file '../../../../lib/tasks/china_regions.rake', 'lib/tasks/china_regions.rake' unless File.exist?('lib/tasks/china_regions.rake')
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
