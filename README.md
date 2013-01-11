# ChinaRegions

中国省份，城市，地区［地级市］. 紧支持 Ruby on Rails 程序.
       

## How to use it

添加一下代码到你的 Gemfile:

gem 'china_regions', :git => 'git://github.com/encoreshao/china_regions.git'. 

bundle install

最后执行:

    rails g china_regions:install
   
   数据迁移:
   * 执行 `rake db:migrate` 添加三张表(provinces, cities, districts).
   * 执行 `rake china_regions:import` 导入数据.

   Now you have there ActiveRecord modules: `Province`, `City`, `District`.
   
   Run with `rails g` for get generator list.

添加三个model到你应用中:

    rails g china_regions:model

   查看 app/models:
   
    create  app/models/province.rb
    create  app/models/city.rb
    create  app/models/district.rb
   

## Contributing

Thank you for XuHao


## License

ChinaRegions is released under the MIT license.

