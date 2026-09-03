# frozen_string_literal: true

require 'spec_helper'

RSpec.describe City, type: :model do
  let(:province) { Province.create!(name: '重庆市', code: 500_000, name_en: 'chongqing') }

  it 'requires a code and a name' do
    city = City.new(province: province)

    expect(city).not_to be_valid
    expect(city.errors[:code]).to be_present
    expect(city.errors[:name]).to be_present
  end

  it 'enforces name uniqueness scoped to province' do
    province.cities.create!(name: '渝中区', code: 500_103)
    other_province = Province.create!(name: '四川省', code: 510_000)

    duplicate_in_same_province = City.new(province: province, name: '渝中区', code: 500_104)
    same_name_other_province   = City.new(province: other_province, name: '渝中区', code: 500_105)

    expect(duplicate_in_same_province).not_to be_valid
    expect(same_name_other_province).to be_valid
  end

  it 'increments the province cities_count via counter_cache' do
    expect { province.cities.create!(name: '渝中区', code: 500_103) }
      .to change { province.reload.cities_count }.by(1)
  end

  it 'delegates province_name to the associated province' do
    city = province.cities.create!(name: '渝中区', code: 500_103)

    expect(city.province_name).to eq('重庆市')
  end

  it 'builds full_name from province and city name' do
    city = province.cities.create!(name: '渝中区', code: 500_103)

    expect(city.full_name).to eq('重庆市 - 渝中区')
  end

  it 'strips administrative suffixes for short_name' do
    city = province.cities.create!(name: '恩施土家族苗族自治州', code: 422_800)

    expect(city.short_name).to eq('恩施土家族苗族')
  end

  describe '#siblings' do
    it 'returns other cities within the same province' do
      city_one = province.cities.create!(name: '渝中区', code: 500_103)
      city_two = province.cities.create!(name: '渝北区', code: 500_112)

      expect(city_one.siblings).to contain_exactly(city_one, city_two)
    end
  end

  describe '.for_province' do
    it 'scopes cities to the given province id' do
      city = province.cities.create!(name: '渝中区', code: 500_103)
      other_province = Province.create!(name: '四川省', code: 510_000)
      other_province.cities.create!(name: '成华区', code: 510_108)

      expect(City.for_province(province.id)).to contain_exactly(city)
    end
  end
end
