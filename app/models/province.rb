# frozen_string_literal: true

class Province < ApplicationRecord
  has_many :cities, dependent: :destroy
  has_many :districts, through: :cities
end
