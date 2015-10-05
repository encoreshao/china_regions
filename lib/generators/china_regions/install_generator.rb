# encoding: utf-8

module ChinaRegions
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    def copy_migration
      Dir["db/migrate/*_china_regions_tables.rb"].each{ |file| File.delete(file) }

      migration_template "migration.rb", "db/migrate/create_china_regions_tables.rb"
    end

    def copy_cities
      copy_file('cities.yml', 'config/cities.yml') unless File::exists?("config/cities.yml")
    end

    def copy_locales
      unless File::exists?("config/locales/regions.en.yml")
        copy_file "../../../../config/locales/en.yml", "config/locales/regions.en.yml"
      end
      unless File::exists?("config/locales/regions.zh.yml")
        copy_file "../../../../config/locales/zh.yml", "config/locales/regions.zh.yml"
      end
    end

    def copy_rake_tasks
      unless File::exists?("lib/tasks/china_regions.rake")
        copy_file "../../../../lib/tasks/china_regions.rake", "lib/tasks/china_regions.rake"
      end
    end

    def execute_migrate
      rake("db:migrate")
    end

    def import_cities_to_database
      rake('china_regions:import')
    end

    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end
  end
end
