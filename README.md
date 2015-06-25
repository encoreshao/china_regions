# ChinaRegions

中国省份，城市，地区［地级市］. 紧支持 Ruby on Rails 程序. Ruby Version ( > 1.9.x ) Rails Version ( > 4.x.x )

## How to update

If you are using ChinaRegions version 0.1.x be sure to run:

    rails g china_regions:regions

to have the javascript file copied over into your project.

## How to use it

添加一下代码到你的 Gemfile:

gem 'china_regions'

or

gem 'china_regions',    :git => 'git://github.com/encoreshao/china_regions.git'

bundle install

执行:

    rails g china_regions:install

   随后你可以看到控制台:
   * 创建 migration 文件到db/migrate 目录 db/migrate/xxxxxxxxxxx_create_china_regions_tables.rb
   * 创建 数据源 cities.yml 到 config 目录.  config/cities.yml
   * 创建 regions.en.yml 和 regions.zh.yml 文件到 config/locales 文件下
   * 执行 `rake db:migrate` 添加三张表(provinces, cities, districts).
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

Thank you for XuHao


## License

ChinaRegions is released under the MIT license.

