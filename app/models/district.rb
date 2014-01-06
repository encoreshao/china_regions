# encoding: utf-8

class District < ActiveRecord::Base

  attr_accessor :name, :city_id, :name_en, :name_abbr

  belongs_to :city

  scope :with_city, ->(city) { where(city_id: city) }

  def province
    city.province
  end

  def short_name
    @short_name ||= name.gsub(/区|县|市|自治县/, '')
  end

  def siblings
    @siblings ||= scoped.with_city(self.city_id)
  end

end
