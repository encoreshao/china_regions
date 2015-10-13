# ChinaRegions

中国省份，城市，地区［地级市］
Ruby on Rails 程式代码, Ruby ( > 1.9.x ) And Rails (> 4.0)

## How to update

If you are using ChinaRegions version 0.1.x be sure to run:

    rails g china_regions:regions

to have the javascript file copied over into your project.

## How to use it

添加以下代码到你的 Gemfile:

gem 'china_regions'

OR

gem 'china_regions',  github: 'encoreshao/china_regions'

bundle install

执行:

    rails g china_regions:install

   随后你可以看到控制台发生的变化:
   * 复制 db/migrate/xxxxxxxxxxx_create_china_regions_tables.rb 文件到db/migrate 目录
   * 复制 数据源 cities.yml 到 config 目录.  config/cities.yml
   * 复制 regions.en.yml 和 regions.zh.yml 文件到 config/locales 目录
   * 执行 `rake db:migrate` 创建所需的表 (provinces, cities, districts).
   * 执行 `rake china_regions:import` 导入数据.


此时 你可能需要添加三个 models[`Province`, `City`, `District`] 到你应用中:

    你可以执行 `rails g` 查看到 generator LIST.

    执行 rails g china_regions:regions

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


Preselect Province:

    = form_for @article do |f|

      = f.region_select [:province, :city, :district], province: "chongqing"

      OR

      = f.region_select [:province, :city, :district], province: "重庆市"

Prioritize Choice:

    = form_for @article do |f|

      = f.region_select [:province, :city, :district], priority: { province: ["重庆市"], district: %w(巴南区 北碚区 渝北区) }

## Contributing

We have a list of valued contributors. Check them all at:

https://github.com/encoreshao/china_regions/graphs/contributors


## License

ChinaRegions is released under the MIT license.

