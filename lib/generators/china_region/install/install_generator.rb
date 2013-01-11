module ChinaRegion
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    def copy_migration_file
      migration_template "migration.rb", "db/migrate/create_china_region_tables.rb"
    end
    
    def copy_cities_file
      copy_file 'cities.yml', 'config/cities.yml'
    end
    
    def execute_migrate
      rake("db:migrate")
    end
    
    def import_cities_to_database
      rake('china_region:import')
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
