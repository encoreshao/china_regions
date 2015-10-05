# ChinaRegions

中国省份，城市，地区［地级市］. Ruby on Rails 程式代码. ruby version ( > 1.9.x ) and rails version (> 3.0)

## How to use it

添加一下代码到你的 Gemfile:

gem 'china_regions'

or

gem 'china_regions', github: 'encoreshao/china_regions'

bundle install

执行:

    rails g china_regions:install

   随后你可以看到控制台发生的变化:
   * 创建 db/migrate/xxxxxxxxxxx_create_china_regions_tables.rb 文件到db/migrate 目录
   * 添加 数据源 cities.yml 到 config 目录.  config/cities.yml
   * 创建 regions.en.yml 和 regions.zh.yml 文件到 config/locales 文件下
   * 执行 `rake db:migrate` 添加三张表(provinces, cities, districts).
   * 执行 `rake china_regions:import` 导入数据.


此时 你可能需要添加三个 models[`Province`, `City`, `District`] 到你应用中:

    你可以执行 `rails g` 查看到 generator LIST.

    执行 rails g china_regions:regions models

   查看 app/models:

    create  app/models/province.rb
    create  app/models/city.rb
    create  app/models/district.rb

## How to view

范例:

    = form_for @article do |f|

      = f.region_select [:province, :city, :district]

      # form_tag
      = region_select :article, :province_id
      = region_select :article, :city_id
      = region_select :article, :district_id

      OR

      = region_select :article, :province
      = region_select :article, :city
      = region_select :article, :district

      = f.submit class: 'btn'

添加前缀名:

    = form_for @article do |f|

      = f.region_select [:province, :city, :district], :prefix => "home"
      = f.region_select [:province, :city, :district], :prefix => "work"


## Contributing

Thank you for XuHao


## License

ChinaRegions is released under the MIT license.

