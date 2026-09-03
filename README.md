# ChinaRegions

[![Gem Version](https://badge.fury.io/rb/china_regions.svg)](https://badge.fury.io/rb/china_regions)
[![CI](https://github.com/encoreshao/china_regions/actions/workflows/ci.yml/badge.svg)](https://github.com/encoreshao/china_regions/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/encoreshao/china_regions/badge.svg)](https://coveralls.io/github/encoreshao/china_regions)

[README](README.md) | [中文文档](README.zh.md)

ChinaRegions is a Rails engine that provides cascading province / city / district [prefecture-level city] dropdowns for China, backed by the official administrative division data.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Basic select](#basic-select)
  - [Prefix](#prefix)
  - [Pre-selected province](#pre-selected-province)
  - [Priority ordering](#priority-ordering)
  - [Cascading updates (AJAX)](#cascading-updates-ajax)
- [Updating Region Data](#updating-region-data)
- [Data Sources](#data-sources)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## Features

- `region_select` form helper for `form_for`/`form_with`, usable as a single select or an array of cascading selects (`[:province, :city, :district]`).
- Cascading selects update automatically in the browser via `region_select.js`, which calls the engine's `/china_regions/fetch_options` JSON endpoint.
- Supports a field name prefix (for repeated selects on one form), a default pre-selected province, and custom priority ordering of choices.
- Ships `Province`, `City`, and `District` models plus a migration, generators, and rake tasks to download and import the latest official region data.

## Requirements

- Ruby >= 2.6
- Rails (> 4.0)

Tested against Ruby 2.6-3.4 and Rails 5.2-8.0; see the [CI matrix](.github/workflows/ci.yml).

## Installation

Add it to your Gemfile:

```ruby
gem 'china_regions'
```

Install it:

```sh
bundle install
```

Run the generator:

```sh
rails g china_regions:install
```

This copies:

- `db/migrate/xxxxxxxxxxx_create_china_regions_tables.rb` into `db/migrate`
- `regions.en.yml` and `regions.zh.yml` into `config/locales`

Create the tables (`provinces`, `cities`, `districts`):

```sh
rails db:migrate
```

Copy the `Province`, `City`, and `District` models into your app:

```sh
rails g china_regions:regions
```

This adds:

- `app/models/province.rb`
- `app/models/city.rb`
- `app/models/district.rb`
- `app/assets/javascripts/region_select.js`

Make sure `region_select.js` (and jQuery, provided via the `jquery-rails` dependency) is loaded by your asset pipeline so cascading selects update in the browser — e.g. add `//= require region_select` to your `application.js` manifest.

Finally, download and import the latest region data (see [Updating Region Data](#updating-region-data)).

## Usage

### Basic select

```slim
= form_for @article do |f|
  = f.region_select [:province, :city, :district]

  / or, with form_tag-style helpers
  = region_select :article, :province_id
  = region_select :article, :city_id
  = region_select :article, :district_id

  / or, passing the bare field name
  = region_select :article, :province
  = region_select :article, :city
  = region_select :article, :district

  = f.submit class: 'btn'
```

### Prefix

Add a prefix so the same fields can appear more than once on a form (e.g. a "home" and "work" address):

```slim
= form_for @article do |f|
  = f.region_select [:province, :city, :district], prefix: "home"
  = f.region_select [:province, :city, :district], prefix: "work"
```

### Pre-selected province

Preselect a province (by English or Chinese name, or by id) and prefill its cities and districts:

```slim
= form_for @article do |f|
  = f.region_select [:province, :city, :district], default: { province: "chongqing" }

  / or
  = f.region_select [:province, :city, :district], default: { province: "重庆市" }
```

### Priority ordering

Move specific choices to the front of a select's option list:

```slim
= form_for @article do |f|
  = f.region_select [:province, :city, :district],
          priority: {
            province: ["重庆市"],
            district: %w(巴南区 北碚区 渝北区)
          }
```

### Cascading updates (AJAX)

Each rendered select carries `data-region-klass` and `data-region-target` attributes. `region_select.js` listens for `change` events on `.region_select` elements and fetches the next select's options from `ChinaRegions::FetchOptionsController` (mounted at `/china_regions/fetch_options`), so picking a province repopulates the city select, and picking a city repopulates the district select — no extra setup required beyond loading the JS asset.

## Updating Region Data

Download and import the latest official region data:

```sh
rails china_regions:all

# or, as two separate steps
rails china_regions:download
rails china_regions:import
```

- `china_regions:download` fetches the latest data from `Administrative-divisions-of-China` into `db/regions/pca-code.json`.
- `china_regions:import` imports that file into the `provinces`, `cities`, and `districts` tables.

## Data Sources

- Ministry of Civil Affairs, National Bureau of Statistics:
  - [State Statistics Bureau of the People's Republic of China — Statistical Divisions and Urban-Rural Division Codes](http://www.stats.gov.cn/tjsj/tjbz/tjyqhdmhcxhfdm/)
  - [State Statistics Bureau of the People's Republic of China — Statistical Division Codes and Urban-Rural Division Codes Compilation Rules](http://www.stats.gov.cn/tjsj/tjbz/200911/t20091125_8667.html)
- Currently updated to the [2018 zoning and urban-rural division codes (cut-off 2018-10-31, released 2019-01-31)](http://www.stats.gov.cn/tjsj/tjbz/tjyqhdmhcxhfdm/2018/index.html).

## Testing

```sh
bundle exec rspec
bundle exec rubocop
```

The gem is also verified against every supported Rails version via [Appraisal](Appraisals):

```sh
bundle exec appraisal install
bundle exec appraisal rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/encoreshao/china_regions. See the full list of contributors at https://github.com/encoreshao/china_regions/graphs/contributors.

## License

Copyright © 2020-2026 Encore Shao. See [LICENSE](LICENSE) for details.
