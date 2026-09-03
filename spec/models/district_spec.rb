# frozen_string_literal: true

require 'spec_helper'

RSpec.describe District, type: :model do
  let(:province) { Province.create!(name: '重庆市', code: 500_000, name_en: 'chongqing') }
  let(:city) { province.cities.create!(name: '渝中区', code: 500_103) }

  it 'requires a name' do
    district = District.new(city: city)

    expect(district).not_to be_valid
    expect(district.errors[:name]).to be_present
  end

  it 'enforces name uniqueness scoped to city' do
    city.districts.create!(name: '解放碑街道', code: 500_103_001)
    other_city = province.cities.create!(name: '渝北区', code: 500_112)

    duplicate_in_same_city = District.new(city: city, name: '解放碑街道', code: 500_103_002)
    same_name_other_city   = District.new(city: other_city, name: '解放碑街道', code: 500_112_001)

    expect(duplicate_in_same_city).not_to be_valid
    expect(same_name_other_city).to be_valid
  end

  it 'increments the city districts_count via counter_cache' do
    expect { city.districts.create!(name: '解放碑街道', code: 500_103_001) }
      .to change { city.reload.districts_count }.by(1)
  end

  it 'delegates city_name to the associated city' do
    district = city.districts.create!(name: '解放碑街道', code: 500_103_001)

    expect(district.city_name).to eq('渝中区')
  end

  it 'exposes the province through the city' do
    district = city.districts.create!(name: '解放碑街道', code: 500_103_001)

    expect(district.province).to eq(province)
  end

  it 'builds full_name from province, city, and district name' do
    district = city.districts.create!(name: '解放碑街道', code: 500_103_001)

    expect(district.full_name).to eq('重庆市 - 渝中区 - 解放碑街道')
  end

  it 'strips administrative suffixes for short_name' do
    district = city.districts.create!(name: '石柱土家族自治县', code: 500_240)

    expect(district.short_name).to eq('石柱土家族')
  end

  describe '#siblings' do
    it 'returns other districts within the same city' do
      district_one = city.districts.create!(name: '解放碑街道', code: 500_103_001)
      district_two = city.districts.create!(name: '大坪街道', code: 500_103_002)

      expect(district_one.siblings).to contain_exactly(district_one, district_two)
    end
  end

  describe '.for_city' do
    it 'scopes districts to the given city id' do
      district = city.districts.create!(name: '解放碑街道', code: 500_103_001)
      other_city = province.cities.create!(name: '渝北区', code: 500_112)
      other_city.districts.create!(name: '双龙湖街道', code: 500_112_001)

      expect(District.for_city(city.id)).to contain_exactly(district)
    end
  end
end
