# frozen_string_literal: true

class CreateChinaRegionsTables < ActiveRecord::Migration
  def change
    setup_provinces unless table_exists? 'provinces'
    setup_citites   unless table_exists? 'cities'
    setup_districts unless table_exists? 'districts'
  end

  def setup_provinces
    create_table :provinces do |t|
      t.string :name
      t.integer :code
      t.string :name_en
      t.string :name_abbr

      t.timestamps
    end

    add_index :provinces, :name
  end

  def setup_citites
    create_table :cities do |t|
      t.string :name
      t.integer :code
      t.integer :province_id
      t.integer :level
      t.string :name_en
      t.string :name_abbr

      t.timestamps
    end

    add_index :cities, :name
    add_index :cities, :province_id
  end

  def setup_districts
    create_table :districts do |t|
      t.string :name
      t.integer :city_id
      t.integer :code
      t.string :name_en
      t.string :name_abbr

      t.timestamps
    end

    add_index :districts, :name
    add_index :districts, :city_id
  end
end
