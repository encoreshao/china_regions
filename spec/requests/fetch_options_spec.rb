# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'ChinaRegions::FetchOptionsController', type: :request do
  let!(:chongqing) { Province.create!(name: '重庆市', code: 500_000, name_en: 'chongqing') }
  let!(:sichuan) { Province.create!(name: '四川省', code: 510_000, name_en: 'sichuan') }
  let!(:yuzhong) { chongqing.cities.create!(name: '渝中区', code: 500_103, level: 4) }
  let!(:jiangbei) { chongqing.cities.create!(name: '江北区', code: 500_105, level: 1) }

  it 'returns the cities for a given province, ordered by level' do
    get '/china_regions/fetch_options', params: { klass: 'city', parent_klass: 'province', parent_id: chongqing.id }

    names = JSON.parse(response.body).map { |row| row['name'] }

    expect(response).to have_http_status(:ok)
    expect(names).to eq(%w[江北区 渝中区])
  end

  it 'excludes cities belonging to a different province' do
    get '/china_regions/fetch_options', params: { klass: 'city', parent_klass: 'province', parent_id: sichuan.id }

    expect(JSON.parse(response.body)).to eq([])
  end

  it 'returns an empty array when required params are missing' do
    get '/china_regions/fetch_options', params: { klass: 'city', parent_klass: 'province' }

    expect(JSON.parse(response.body)).to eq([])
  end

  it 'returns an empty array for an invalid parent_klass' do
    get '/china_regions/fetch_options', params: { klass: 'city', parent_klass: 'district', parent_id: yuzhong.id }

    expect(JSON.parse(response.body)).to eq([])
  end
end
