# ChinaRegions

Chinese provinces, cities, regions [prefecture-level cities] Ruby on Rails code, Ruby (> 1.9.x) And Rails (> 4.0)

[![Gem Version](https://badge.fury.io/rb/crunchbase-ruby-library.svg)](https://badge.fury.io/rb/crunchbase-ruby-library)
[![Build Status](https://travis-ci.org/encoreshao/crunchbase-ruby-library.svg?branch=master)](https://travis-ci.org/encoreshao/crunchbase-ruby-library)
[![Coverage Status](https://coveralls.io/repos/github/encoreshao/crunchbase-ruby-library/badge.svg)](https://coveralls.io/github/encoreshao/crunchbase-ruby-library)

### How to update data

If you are using ChinaRegions version 0.1.x be sure to run:

    rails g china_regions:regions

to have the javascript file copied over into your project.

### Installation

Add it to your Gemfile:

    gem 'china_regions'

Run the following command to install it:

    bundle install

Run the generator:

    rails g china_regions:install

   Then you can see the changes that happened to the console:
   * Copy `db/migrate/xxxxxxxxxxx_create_china_regions_tables.rb` to `db/migrate` folder.
   * Copy `regions.en.yml` and `regions.zh.yml` files to `config/locales` folders

Create tables (provinces, cities, districts):

    rake db:migrate

Copy Models [Province`, `City`, `District] into your project:

  please run `rails g` see the generator list.

    rails g china_regions:regions

Newly added models:

  - create  app/models/province.rb
  - create  app/models/city.rb
  - create  app/models/district.rb

Download and import the latest regions to your project:

    rake china_regions:all

  * 1. Downloading regions from `Administrative-divisions-of-China` to `db/regions` folder.
    - db/regions/pca-code.json
  * 2. Import the regions into provinces and cities, districts

### Usage

Example:

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

Add prefix name:

    = form_for @article do |f|

      = f.region_select [:province, :city, :district], :prefix => "home"
      = f.region_select [:province, :city, :district], :prefix => "work"


Pre-selected province:

    = form_for @article do |f|

      = f.region_select [:province, :city, :district], province: "chongqing"

      OR

      = f.region_select [:province, :city, :district], province: "重庆市"

Prior choice:

    = form_for @article do |f|

      = f.region_select [:province, :city, :district], priority: { province: ["重庆市"], district: %w(巴南区 北碚区 渝北区) }


### Other languages

[Chinese](https://github.com/encoreshao/china_regions/blob/master/README.zh.md)

### Contributing

We have a list of valued contributors. Check them all at:

https://github.com/encoreshao/china_regions/graphs/contributors


### License

Copyright © 2018-07 Encore Shao. See LICENSE for details.

