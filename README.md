# ChinaRegions

中国省份，城市，地区［地级市］. 紧支持 Ruby on Rails 程序.
       

## How to use it

添加一下代码到你的 Gemfile:

gem 'china_regions',    :git => 'git://github.com/encoreshao/china_regions.git'

bundle install

执行:

    rails g china_regions:install
   
   随后你可以看到控制台:
   * 复制 数据源cities 到 config 目录.  config/cities.yml
   * 创建 migration 文件到db/migrate 目录 db/migrate/create_china_regions_tables.rb
   * 执行 `rake db:migrate` 添加三张表(provinces, cities, districts).
   * 执行 `rake china_regions:import` 导入数据.


此时 你可能需要添加三个model[`Province`, `City`, `District`]到你应用中:
    
    你可以执行 `rails g` 查看到 generator LIST.

    执行 rails g china_regions:regions models

   查看 app/models:
   
    create  app/models/province.rb
    create  app/models/city.rb
    create  app/models/district.rb
   

## Contributing

Thank you for XuHao


## License

ChinaRegions is released under the MIT license.

