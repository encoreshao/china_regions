# encoding: utf-8

class CreateChinaRegionsTables < ActiveRecord::Migration
  def change
    unless table_exists? 'provinces'
      create_table :provinces do |t|
        t.string :name
        t.string :name_en
        t.string :name_abbr

        t.timestamps
      end

      add_index :provinces, :name
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
    end
  end
end
