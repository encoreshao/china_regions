# encoding: utf-8

require 'yaml'

namespace :china_regions do
  desc "Import regions to database from config/cities.yml"

  task :import => :environment do
    file_path = File.join(Rails.root, 'config', 'cities.yml')
    data = File.open(file_path) { |file| YAML.load(file) }
    remove_china_regins && load_to_db(data)
    puts "Data import is done."
  end
  
  def remove_china_regins
    Province.delete_all && City.delete_all && District.delete_all
  end

  def load_to_db(data)
    data.each do |province_name, province_hash|
      province = Province.create({ 
        name:       province_name, 
        name_en:    province_hash['name_en'], 
        name_abbr:  province_hash['name_abbr']
      })
      province_hash['cities'].each do |city_name, city_hash|
        city = City.create({ 
          province_id:  province.id,
          name:         city_name, 
          name_en:      city_hash['name_en'], 
          name_abbr:    city_hash['name_abbr'], 
          zip_code:     city_hash['zip_code'],
          level:        city_hash['level'] || 4
        })
        districts_hash = city_hash['districts']

        districts_hash.each do |district_name, district_hash|
          District.create({ 
            city_id:    city.id,
            name:       district_name, 
            name_en:    district_hash['name_en'], 
            name_abbr:  district_hash['name_abbr']
          })
        end
      end
    end
  end
end