# frozen_string_literal: true

class Province < ApplicationRecord
  # Validations
  validates :code, presence: true
  validates :name, presence: true, uniqueness: {
    case_sensitive: false
  }

  # Relationships
  has_many :cities, dependent: :destroy
  has_many :districts, through: :cities
end
