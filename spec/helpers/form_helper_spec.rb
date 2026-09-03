# frozen_string_literal: true

require 'spec_helper'

class DummyArticle
  include ActiveModel::Model

  attr_accessor :province_id, :city_id, :district_id

  # Handles prefixed ids (e.g. home_province_id) generically, since Rails'
  # select helper needs the object to respond to whatever method it's given.
  def method_missing(name, *args)
    return nil if name.to_s.end_with?('_id')

    super
  end

  def respond_to_missing?(name, include_private = false)
    name.to_s.end_with?('_id') || super
  end
end

RSpec.describe ChinaRegions::Helpers::FormHelper, type: :helper do
  let!(:chongqing) { Province.create!(name: '重庆市', code: 500_000, name_en: 'chongqing') }
  let!(:sichuan) { Province.create!(name: '四川省', code: 510_000, name_en: 'sichuan') }
  let!(:yuzhong) { chongqing.cities.create!(name: '渝中区', code: 500_103) }
  let!(:jiefangbei) { yuzhong.districts.create!(name: '解放碑街道', code: 500_103_001) }

  before { assign(:article, DummyArticle.new) }

  describe 'single field usage' do
    it 'renders a select tag populated with the region options' do
      output = helper.region_select('article', :province_id)

      expect(output).to include('<select')
      expect(output).to include('name="article[province_id]"')
      expect(output).to include('重庆市')
      expect(output).to include('四川省')
    end

    it 'applies the region_select class as an html_option' do
      output = helper.region_select('article', :province)

      expect(output).to include('class="region_select"')
    end
  end

  describe 'array-of-fields usage' do
    it 'populates the first field and leaves subsequent fields empty by default' do
      output = helper.region_select('article', %i[province city district])

      expect(output.scan('<select').size).to eq(3)
      expect(output).to include('重庆市')
      expect(output).to include('data-region-target="article_city_id"')
    end

    it 'adds the given prefix to each field name' do
      output = helper.region_select('article', %i[province city district], prefix: 'home')

      expect(output).to include('name="article[home_province_id]"')
      expect(output).to include('name="article[home_city_id]"')
      expect(output).to include('name="article[home_district_id]"')
    end

    it 'orders choices for the given field according to :priority' do
      output = helper.region_select('article', [:province], priority: { province: ['四川省'] })

      sichuan_index = output.index('四川省')
      chongqing_index = output.index('重庆市')

      expect(sichuan_index).to be < chongqing_index
    end

    it 'preselects city and district choices when :default province is given' do
      output = helper.region_select('article', %i[province city district], default: { province: 'chongqing' })

      expect(output).to include("selected=\"selected\" value=\"#{chongqing.id}\"")
      expect(output).to include('渝中区')
      expect(output).to include('解放碑街道')
    end
  end
end
