# frozen_string_literal: true

class District < ApplicationRecord
  belongs_to :city

  scope :for_city, ->(city_id) { where(city_id: city_id) }

  def province
    city.province
  end

  def short_name
    @short_name ||= name.gsub(/区|县|市|自治县/, '')
  end

  def siblings
    @siblings ||= where(nil).for_city(city_id)
  end
end
