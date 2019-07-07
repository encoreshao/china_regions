# frozen_string_literal: true

class City < ApplicationRecord
  belongs_to :province
  has_many :districts, dependent: :destroy

  scope :for_province, ->(province_id) { where(province_id: province_id) }

  def short_name
    @short_name ||= name.gsub(/市|自治州|地区|特别行政区/, '')
  end

  def siblings
    @siblings ||= where(nil).for_province(province_id)
  end
end
