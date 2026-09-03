# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :provinces, force: true do |t|
    t.string :name
    t.integer :code
    t.string :name_en
    t.string :name_abbr
    t.integer :cities_count, default: 0

    t.timestamps
  end

  add_index :provinces, :name

  create_table :cities, force: true do |t|
    t.string :name
    t.integer :code
    t.integer :province_id
    t.integer :level
    t.string :name_en
    t.string :name_abbr
    t.integer :districts_count, default: 0

    t.timestamps
  end

  add_index :cities, :name
  add_index :cities, :province_id

  create_table :districts, force: true do |t|
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
