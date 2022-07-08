# ChinaRegions

[![Gem Version](https://badge.fury.io/rb/china_regions.svg)](https://badge.fury.io/rb/china_regions)
[![Build Status](https://travis-ci.org/encoreshao/china_regions.svg?branch=master)](https://travis-ci.org/encoreshao/china_regions)
[![Coverage Status](https://coveralls.io/repos/github/encoreshao/china_regions/badge.svg)](https://coveralls.io/github/encoreshao/china_regions)

[README](README.md) | [中文文档](README.zh.md)

ChinaRegions provides Ruby on Rails code for provinces, cities, and districts [prefecture-level cities] in China. The code need to requires Ruby (> 1.9.x) and Rails (> 4.0).

### Data Sources

*   Ministry of Civil Affairs, National Bureau of Statistics:
    * [State Statistics Bureau of the People's Republic of China-Statistical Divisions and Urban-Rural Division Codes](http://www.stats.gov.cn/tjsj/tjbz/tjyqhdmhcxhfdm/)
    * [State Statistics Bureau of the People's Republic of China-Statistical Division Codes and Urban-rural Division Codes Compilation Rules](http://www.stats.gov.cn/tjsj/tjbz/200911/t20091125_8667.html)
*   This item has been updated to:
    * [2018 zoning code and urban-rural division code for statistics (cut-off time: 2018-10-31, release time: 2019-01-31)](http://www.stats.gov.cn/tjsj/tjbz/tjyqhdmhcxhfdm/2018/index.html)

### How to update data

If you are using ChinaRegions version 0.1.x be sure to run:

```
rails g china_regions:regions
```

to have the javascript file copied over into your project.

### Installation

Add it to your Gemfile:

```
gem 'china_regions'
```

Run the following command to install it:

```
bundle install
```

Run the generator:

```
rails g china_regions:install
```

Then you can see the changes that happened to the console:

  - Copy `db/migrate/xxxxxxxxxxx_create_china_regions_tables.rb` to `db/migrate` folder.
  - Copy `regions.en.yml` and `regions.zh.yml` files to `config/locales` folders

Create tables (provinces, cities, districts):

```
rake db:migrate
```

Copy Models [`Province`, `City`, `District`] into your project:

```
rails g china_regions:regions
```

Newly added models:

- create  app/models/province.rb
- create  app/models/city.rb
- create  app/models/district.rb

Download and import the latest regions to your project:

```
rake china_regions:all

OR

rake china_regions:download
rake china_regions:import
```

- Downloading regions from `Administrative-divisions-of-China` to `db/regions` folder.
  - db/regions/pca-code.json
- Import the regions into provinces and cities, districts

### Usage

Example:

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

Add prefix name:

```
= form_for @article do |f|

  = f.region_select [:province, :city, :district], :prefix => "home"
  = f.region_select [:province, :city, :district], :prefix => "work"
```

Pre-selected province:

```
= form_for @article do |f|
  = f.region_select [:province, :city, :district], province: "chongqing"

  OR

  = f.region_select [:province, :city, :district], province: "重庆市"
```

Prior choice:

```
= form_for @article do |f|
  = f.region_select [:province, :city, :district],
          priority: {
            province: ["重庆市"],
            district: %w(巴南区 北碚区 渝北区)
          }
```

### Contributing

  We have a list of valued contributors. Check them all at: https://github.com/encoreshao/china_regions/graphs/contributors

### License

Copyright © 2020-02 Encore Shao. See LICENSE for details.

