# frozen_string_literal: true

class District < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: {
    case_sensitive: false,
    scope: [:city_id]
  }

  # Relationships
  belongs_to :city, counter_cache: true
  delegate :name, to: :city

  # Filters
  scope :for_city, ->(city_id) { where(city_id: city_id) }

  def full_name
    [province.name, city_name, name].compact.join(' - ')
  end

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
