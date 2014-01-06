# encoding: utf-8

class City < ActiveRecord::Base
  attr_accessor :name, :province_id, :level, :zip_code, :name_en, :name_abbr

  belongs_to :province
  has_many :districts, dependent: :destroy

  scope :with_province, ->(province) { where(province_id: province) }

  def short_name
    @short_name ||= name.gsub(/市|自治州|地区|特别行政区/, '')
  end

  def siblings
    @siblings ||= scoped.with_province(self.province_id)
  end

end
