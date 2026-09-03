# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Province, type: :model do
  it 'requires a code' do
    province = Province.new(name: '重庆市')
    expect(province).not_to be_valid
    expect(province.errors[:code]).to be_present
  end

  it 'requires a name' do
    province = Province.new(code: 500_000)
    expect(province).not_to be_valid
    expect(province.errors[:name]).to be_present
  end

  it 'enforces case-insensitive uniqueness of name' do
    Province.create!(name: '重庆市', code: 500_000)
    duplicate = Province.new(name: '重庆市', code: 500_001)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:name]).to be_present
  end

  it 'has many cities and districts through cities' do
    province = Province.create!(name: '重庆市', code: 500_000, name_en: 'chongqing')
    city = province.cities.create!(name: '渝中区', code: 500_103)
    district = city.districts.create!(name: '解放碑街道', code: 500_103_001)

    expect(province.cities).to contain_exactly(city)
    expect(province.districts).to contain_exactly(district)
  end

  describe '.filter_by' do
    before do
      Province.create!(name: '重庆市', code: 500_000, name_en: 'chongqing')
      Province.create!(name: '四川省', code: 510_000, name_en: 'sichuan')
    end

    it 'finds a province by its Chinese name' do
      expect(Province.filter_by('重庆市').first.name_en).to eq('chongqing')
    end

    it 'finds a province by its English name' do
      expect(Province.filter_by('sichuan').first.name).to eq('四川省')
    end

    it 'returns nothing when no province matches' do
      expect(Province.filter_by('nowhere')).to be_empty
    end
  end
end
