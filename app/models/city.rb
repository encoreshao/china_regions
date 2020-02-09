# frozen_string_literal: true

class City < ApplicationRecord
  # Validations
  validates :code, presence: true
  validates :name, presence: true, uniqueness: {
    case_sensitive: false,
    scope: [:province_id]
  }

  # Relationships
  belongs_to :province, counter_cache: true
  delegate :name, to: :province, prefix: true

  has_many :districts, dependent: :destroy

  # Fileters
  scope :for_province, ->(province_id) { where(province_id: province_id) }

  def full_name
    [province_name, name].compact.join(' - ')
  end

  def short_name
    @short_name ||= name.gsub(/市|自治州|地区|特别行政区/, '')
  end

  def siblings
    @siblings ||= where(nil).for_province(province_id)
  end
end
