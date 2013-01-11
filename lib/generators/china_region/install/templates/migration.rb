class CreateChinaRegionTables < ActiveRecord::Migration
  def change
    unless table_exists? 'provinces'
      create_table :provinces do |t|
        t.string :name
        t.string :name_en
        t.string :name_abbr
        t.timestamps
      end
      
      add_index :provinces, :name
      add_index :provinces, :name_en
      add_index :provinces, :name_abbr
    end
    
    unless table_exists? 'cities'
      create_table :cities do |t|
        t.string :name
        t.integer :province_id
        t.integer :level
        t.string :zip_code
        t.string :name_en
        t.string :name_abbr
        t.timestamps
      end
      add_index :cities, :name
      add_index :cities, :province_id
      add_index :cities, :level
      add_index :cities, :zip_code
      add_index :cities, :name_en
      add_index :cities, :name_abbr
    end
    
    unless table_exists? 'districts'  
      create_table :districts do |t|
        t.string :name
        t.integer :city_id
        t.string :name_en
        t.string :name_abbr
        t.timestamps
      end
      add_index :districts, :name
      add_index :districts, :city_id
      add_index :districts, :name_en
      add_index :districts, :name_abbr
    end
  end
end