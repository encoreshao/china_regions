# frozen_string_literal: true

class District < ActiveRecord::Base
  belongs_to :city

  scope :with_city, ->(city) { where(city_id: city) }

  def province
    city.province
  end

  def short_name
    @short_name ||= name.gsub(/区|县|市|自治县/, '')
  end

  def siblings
    @siblings ||= where(nil).with_city(city_id)
  end
end
