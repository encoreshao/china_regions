# ChinaRegions

中国省份，城市，地区［地级市］Ruby on Rails 程式代码, Ruby (> 1.9.x) And Rails (> 4.0)

[![Gem Version](https://badge.fury.io/rb/china-regions.svg)](https://badge.fury.io/rb/china-regions)
[![Build Status](https://travis-ci.org/encoreshao/china-regions.svg?branch=master)](https://travis-ci.org/encoreshao/china-regions)
[![Coverage Status](https://coveralls.io/repos/github/encoreshao/china-regions/badge.svg)](https://coveralls.io/github/encoreshao/china-regions)

### 如何更新数据文件

复制所需文件到你的项目中:

    >> rails g china_regions:regions

### 如何引入china_regions到你的项目

添加以下代码到你的 Gemfile:

    gem 'china_regions'

安装:

    >> bundle install

#### 开始构建城市数据

复制所需文件到你的项目中:

    >> rails g china_regions:install

   随后你可以看到控制台发生的变化:
   * 复制 db/migrate/xxxxxxxxxxx_create_china_regions_tables.rb 文件到db/migrate 目录
   * 复制 数据源 cities.yml 到 config 目录.  config/cities.yml
   * 复制 regions.en.yml 和 regions.zh.yml 文件到 config/locales 目录

创建所需的表 (provinces, cities, districts):

    >> rake db:migrate

导入数据到对应表中:

    >> rake china_regions:import


将所需的模型(Models) [`Province`, `City`, `District`] 到您的应用程式中:

    你可以执行 `rails g` 查看到 generator LIST.

     >> rails g china_regions:regions

查看 app/models:

    create  app/models/province.rb
    create  app/models/city.rb
    create  app/models/district.rb

### 如何在View中使用

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


预选则省份:

    = form_for @article do |f|

      = f.region_select [:province, :city, :district], province: "chongqing"

      OR

      = f.region_select [:province, :city, :district], province: "重庆市"

优先选择:

    = form_for @article do |f|

      = f.region_select [:province, :city, :district], priority: { province: ["重庆市"], district: %w(巴南区 北碚区 渝北区) }


### 其它语言

[English Readme](https://github.com/encoreshao/china_regions/blob/master/README.md)

### 贡献者

你可以在这里查看到所有的代码贡献者:

https://github.com/encoreshao/china_regions/graphs/contributors


### 许可

Copyright © 2018-07 Encore Shao. See LICENSE for details.

