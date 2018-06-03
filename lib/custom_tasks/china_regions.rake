# frozen_string_literal: true

require 'yaml'

namespace :china_regions do
  desc 'Import regions to database from config/cities.yml'
  task import: :environment do
    file_path = File.join(Rails.root, 'config', 'cities.yml')
    data = File.open(file_path) { |file| YAML.safe_load(file) }
    remove_china_regions && load_to_db(data)

    puts "\n China's provinces, city, region data import is complete."
  end

  def remove_china_regions
    Province.delete_all && City.delete_all && District.delete_all
  end

  def load_to_db(data)
    data.each do |province_name, province_hash|
      province = creating_province(province_name, province_hash)

      province_hash['cities'].each do |city_name, city_hash|
        city = creating_city(province.id, city_name, city_hash)

        creating_districts(city.id, city_hash)
      end
      print '.'
    end
  end

  def creating_province(province_name, province_hash)
    province_parameters = province_params(
      name:       province_name,
      name_en:    province_hash['name_en'],
      name_abbr:  province_hash['name_abbr']
    )

    Province.create(province_parameters)
  end

  def creating_city(province_id, city_name, city_hash)
    city_parameters = city_params(
      province_id:  province_id,
      name:         city_name,
      name_en:      city_hash['name_en'],
      name_abbr:    city_hash['name_abbr'],
      zip_code:     city_hash['zip_code'],
      level:        city_hash['level'] || 4
    )

    City.create(city_parameters)
  end

  def creating_districts(city_id, city_hash)
    districts_hash = city_hash['districts']

    districts_hash.each do |district_name, district_hash|
      creating_district(city_id, district_name, district_hash)
    end
  end

  def creating_district(city_id, district_name, district_hash)
    district_parameters = district_params(
      city_id:    city_id,
      name:       district_name,
      name_en:    district_hash['name_en'],
      name_abbr:  district_hash['name_abbr']
    )
    District.create(district_parameters)
  end

  private
  def province_params(raw_parameters)
    parameters = ActionController::Parameters.new(raw_parameters)
    parameters.permit(:name, :name_en, :name_abbr)
  end

  def city_params(raw_parameters)
    parameters = ActionController::Parameters.new(raw_parameters)
    parameters.permit(:province_id, :name, :name_en, :name_abbr, :zip_code, :level)
  end

  def district_params(raw_parameters)
    parameters = ActionController::Parameters.new(raw_parameters)
    parameters.permit(:city_id, :name, :name_en, :name_abbr)
  end
end
