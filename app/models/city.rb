# frozen_string_literal: true

class City < ActiveRecord::Base
  belongs_to :province
  has_many :districts, dependent: :destroy

  scope :with_province, ->(province) { where(province_id: province) }

  def short_name
    @short_name ||= name.gsub(/市|自治州|地区|特别行政区/, '')
  end

  def siblings
    @siblings ||= where(nil).with_province(province_id)
  end
end
