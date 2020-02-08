# frozen_string_literal: true

namespace :china_regions do
  desc 'Download and import regions into tables'
  task all: :environment do
    Rake::Task['china_regions:download'].invoke
    Rake::Task['china_regions:import'].invoke
  end

  desc 'Download regions from `Administrative-divisions-of-China`'
  task download: :environment do
    ChinaRegions::Download.all
  end

  desc 'Import provinces and cities and areas to database'
  task import: :environment do
    ChinaRegions::Import.all
  end
end

module ChinaRegions
  module Download
    require "down"

    module_function

    def all(filename = 'pca-code.json')
      detect_folder

      downloading(filename)
    end

    def downloading(filename)
      down(filename)

      move_to(filename)
    end

    def down(filename)
      Down.download(
        github_url(filename),
        destination: File.join(Rails.root, 'db', 'regions')
      )
    end

    def detect_folder
      FileUtils.mkdir_p File.join(Rails.root, 'db', 'regions')
    end

    def github_url(filename)
      [
        'https://raw.githubusercontent.com',
        'encoreshao',
        'Administrative-divisions-of-China',
        'master',
        'dist',
        filename
      ].join('/')
    end

    def move_to(filename)
      src_file = Dir.glob(File.join(Rails.root, 'db', 'regions', "*.json")).max_by { |f| File.mtime(f) }

      FileUtils.mv src_file, File.join(Rails.root, 'db', 'regions', filename)
    end
  end

  module Import
    require 'json'
    require 'ruby-pinyin'

    module_function

    def all(filename = 'pca-code.json')
      data_hash(filename).each { |province_hash| creating_province(province_hash) }

      puts "Imported done!"
      puts ''
      puts "  Total of #{Province.count} provinces."
      puts "  Total of #{City.count} cities."
      puts "  Total of #{District.count} districts."
    end

    def creating_province(prov_hash)
      province = Province.find_or_create_by(name: prov_hash['name'])
      province.update(build_params(prov_hash['name'], prov_hash['code']))

      prov_hash["children"].each { |city_hash| creating_city(province, city_hash) }
    end

    def creating_city(province, city_hash)
      city = City.find_or_create_by(province: province, name: city_hash['name'])
      city_params = build_params(city_hash['name'], city_hash['code'])
                    .merge(city_level(city_hash['name']))
      city.update(city_params)

      city_hash['children'].each { |district| creating_district(city, district) }
    end

    def city_level(city_name)
      {
        level: municipalities.include?(city_name) ? 1 : 4
      }
    end

    def creating_district(city, district_hash)
      district = District.find_or_create_by(city: city, name: district_hash['name'])
      district.update(build_params(district_hash['name'], district_hash['code']))
    end

    def build_params(full_name, code)
      new_name      = convert_pinyin(to_decorate(full_name))
      name_en       = new_name.join
      name_abbr     = new_name.map { |e| e[0] }.join

      {
        code: code,
        name_en: name_en,
        name_abbr: name_abbr
      }
    end

    def convert_pinyin(text)
      PinYin.of_string(text)
    end

    def to_decorate(text)
      text.gsub(/市|自治州|地区|特别行政区|区|县|自治县/, '')
    end

    def municipalities
      %w[北京市 天津市 重庆市 上海市]
    end

    def data_hash(filename)
      @data_hash ||= JSON.parse File.read(latest_file_path(filename))
    end

    def latest_file_path(filename)
      File.join(Rails.root, 'db', 'regions', filename)
    end
  end
end
