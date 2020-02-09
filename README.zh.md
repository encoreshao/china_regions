# ChinaRegions

[![Gem Version](https://badge.fury.io/rb/china-regions.svg)](https://badge.fury.io/rb/china-regions)
[![Build Status](https://travis-ci.org/encoreshao/china-regions.svg?branch=master)](https://travis-ci.org/encoreshao/china-regions)
[![Coverage Status](https://coveralls.io/repos/github/encoreshao/china-regions/badge.svg)](https://coveralls.io/github/encoreshao/china-regions)

ChinaRegions 提供中国的省，市，区[地级市]的 Ruby on Rails的程式代码，代码版本要求 Ruby（> 1.9.x）和Rails（> 4.0).

### 数据来源

*   民政部、国家统计局：
    * [中华人民共和国国家统计局-统计用区划和城乡划分代码](http://www.stats.gov.cn/tjsj/tjbz/tjyqhdmhcxhfdm/)
    * [中华人民共和国国家统计局-统计用区划代码和城乡划分代码编制规则](http://www.stats.gov.cn/tjsj/tjbz/200911/t20091125_8667.html)
*   本项目已更新至：
    * [2018年统计用区划代码和城乡划分代码（截止时间：2018-10-31，发布时间：2019-01-31）](http://www.stats.gov.cn/tjsj/tjbz/tjyqhdmhcxhfdm/2018/index.html)

### 如何更新数据文件

复制所需文件到你的项目中:

```
rails g china_regions:regions
```

### 如何引入china_regions到你的项目

添加以下代码到你的 Gemfile:

```
gem 'china_regions'
```

安装:

```
bundle install
```

#### 开始构建城市数据

复制所需文件到你的项目中:

```
rails g china_regions:install
```

随后你可以看到控制台发生的变化:

- 复制 `db/migrate/xxxxxxxxxxx_create_china_regions_tables.rb` 文件到 `db/migrate` 目录中
- 复制 `regions.en.yml` 和 `regions.zh.yml` 配置文件到 `config/locales` 目录中

创建所需的表 (provinces, cities, districts):

```
rake db:migrate
```

将所需的模型(Models) [`Province`, `City`, `District`] 到您的应用程式中:

```
rails g china_regions:regions
```

查看 app/models:

- create  app/models/province.rb
- create  app/models/city.rb
- create  app/models/district.rb

下载并导入最新数据到你的项目中:

```
rake china_regions:all

OR

rake china_regions:download
rake china_regions:import
```

- 1. 从 `Administrative-divisions-of-China` 下载最新的地区信息到 `db/regions` 目录中.
  - db/regions/pca-code.json
- 2. 将下载后的地区信息导入数据库中

### 如何在View中使用

范例:

```
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
```

添加前缀名:

```
= form_for @article do |f|
  = f.region_select [:province, :city, :district], :prefix => "home"
  = f.region_select [:province, :city, :district], :prefix => "work"
```

预选则省份:

```
= form_for @article do |f|
  = f.region_select [:province, :city, :district], province: "chongqing"

  OR

  = f.region_select [:province, :city, :district], province: "重庆市"
```

优先选择:

```
= form_for @article do |f|
  = f.region_select [:province, :city, :district],
          priority: {
            province: ["重庆市"],
            district: %w(巴南区 北碚区 渝北区)
          }
```

### 其它语言

[English](https://github.com/encoreshao/china_regions/blob/master/README.md)

### 贡献者

你可以在这里查看到所有的代码贡献者: https://github.com/encoreshao/china_regions/graphs/contributors

### 许可

Copyright © 2020-02 Encore Shao. See LICENSE for details.

