# ChinaRegions

[![Gem Version](https://badge.fury.io/rb/china_regions.svg)](https://badge.fury.io/rb/china_regions)
[![CI](https://github.com/encoreshao/china_regions/actions/workflows/ci.yml/badge.svg)](https://github.com/encoreshao/china_regions/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/encoreshao/china_regions/badge.svg)](https://coveralls.io/github/encoreshao/china_regions)

[README](README.md) | [中文文档](README.zh.md)

ChinaRegions 是一个 Rails 引擎，基于官方行政区划数据，为省 / 市 / 区[地级市]提供级联下拉选择框。

## 目录

- [功能特性](#功能特性)
- [环境要求](#环境要求)
- [安装](#安装)
- [使用方法](#使用方法)
  - [基础用法](#基础用法)
  - [前缀](#前缀)
  - [预选择省份](#预选择省份)
  - [优先排序](#优先排序)
  - [级联更新（AJAX）](#级联更新ajax)
- [更新地区数据](#更新地区数据)
- [数据来源](#数据来源)
- [测试](#测试)
- [贡献](#贡献)
- [许可](#许可)

## 功能特性

- 提供 `region_select` 表单帮助方法，可用于 `form_for`/`form_with`，既可以是单个下拉框，也可以是一组级联下拉框（`[:province, :city, :district]`）。
- 级联下拉框通过 `region_select.js` 在浏览器端自动联动更新，该脚本会调用引擎内置的 `/china_regions/fetch_options` JSON 接口。
- 支持字段前缀（用于同一表单中重复出现的下拉组）、默认预选省份，以及自定义的选项优先排序。
- 内置 `Province`、`City`、`District` 模型及对应迁移文件、生成器，以及下载并导入最新官方地区数据的 rake 任务。

## 环境要求

- Ruby >= 2.6
- Rails (> 4.0)

目前在 Ruby 2.6-3.4 和 Rails 5.2-8.0 下均通过测试，详见 [CI 配置](.github/workflows/ci.yml)。

## 安装

添加以下代码到你的 Gemfile:

```ruby
gem 'china_regions'
```

安装:

```sh
bundle install
```

运行生成器:

```sh
rails g china_regions:install
```

这会复制以下文件:

- `db/migrate/xxxxxxxxxxx_create_china_regions_tables.rb` 到 `db/migrate` 目录
- `regions.en.yml` 和 `regions.zh.yml` 到 `config/locales` 目录

创建所需的表 (provinces, cities, districts):

```sh
rails db:migrate
```

将 `Province`、`City`、`District` 模型复制到你的项目中:

```sh
rails g china_regions:regions
```

这会新增:

- `app/models/province.rb`
- `app/models/city.rb`
- `app/models/district.rb`
- `app/assets/javascripts/region_select.js`

请确保你的资源管道加载了 `region_select.js`（以及 `jquery-rails` 依赖提供的 jQuery），级联下拉框才能在浏览器中正常联动更新——例如在 `application.js` 的 manifest 中添加 `//= require region_select`。

最后，下载并导入最新的地区数据（见[更新地区数据](#更新地区数据)）。

## 使用方法

### 基础用法

```slim
= form_for @article do |f|
  = f.region_select [:province, :city, :district]

  / 或者使用 form_tag 风格的帮助方法
  = region_select :article, :province_id
  = region_select :article, :city_id
  = region_select :article, :district_id

  / 或者直接传入字段名
  = region_select :article, :province
  = region_select :article, :city
  = region_select :article, :district

  = f.submit class: 'btn'
```

### 前缀

添加前缀，使同一组字段可以在表单中出现多次（例如「家庭地址」和「工作地址」）:

```slim
= form_for @article do |f|
  = f.region_select [:province, :city, :district], prefix: "home"
  = f.region_select [:province, :city, :district], prefix: "work"
```

### 预选择省份

预选择一个省份（可用中文名、英文名或 id），并预填充对应的市和区:

```slim
= form_for @article do |f|
  = f.region_select [:province, :city, :district], default: { province: "chongqing" }

  / 或者
  = f.region_select [:province, :city, :district], default: { province: "重庆市" }
```

### 优先排序

将指定的选项排到下拉列表前面:

```slim
= form_for @article do |f|
  = f.region_select [:province, :city, :district],
          priority: {
            province: ["重庆市"],
            district: %w(巴南区 北碚区 渝北区)
          }
```

### 级联更新（AJAX）

每个渲染出来的下拉框都带有 `data-region-klass` 和 `data-region-target` 属性。`region_select.js` 会监听 `.region_select` 元素上的 `change` 事件，并向 `ChinaRegions::FetchOptionsController`（挂载在 `/china_regions/fetch_options`）请求下一级的选项数据，因此选择省份会自动更新市的下拉框，选择市会自动更新区的下拉框——除了加载对应的 JS 资源外，无需额外配置。

## 更新地区数据

下载并导入最新的官方地区数据:

```sh
rails china_regions:all

# 或者分两步执行
rails china_regions:download
rails china_regions:import
```

- `china_regions:download` 会从 `Administrative-divisions-of-China` 下载最新数据到 `db/regions/pca-code.json`。
- `china_regions:import` 会将该文件导入到 `provinces`、`cities`、`districts` 表中。

## 数据来源

- 民政部、国家统计局：
  - [中华人民共和国国家统计局-统计用区划和城乡划分代码](http://www.stats.gov.cn/tjsj/tjbz/tjyqhdmhcxhfdm/)
  - [中华人民共和国国家统计局-统计用区划代码和城乡划分代码编制规则](http://www.stats.gov.cn/tjsj/tjbz/200911/t20091125_8667.html)
- 本项目已更新至：[2018年统计用区划代码和城乡划分代码（截止时间：2018-10-31，发布时间：2019-01-31）](http://www.stats.gov.cn/tjsj/tjbz/tjyqhdmhcxhfdm/2018/index.html)。

## 测试

```sh
bundle exec rspec
bundle exec rubocop
```

该 gem 还通过 [Appraisal](Appraisals) 在每个受支持的 Rails 版本下进行验证:

```sh
bundle exec appraisal install
bundle exec appraisal rspec
```

## 贡献

欢迎在 GitHub 上提交 issue 和 pull request：https://github.com/encoreshao/china_regions 。你可以在这里查看到所有的代码贡献者：https://github.com/encoreshao/china_regions/graphs/contributors 。

## 许可

Copyright © 2020-2026 Encore Shao. See [LICENSE](LICENSE) for details.
