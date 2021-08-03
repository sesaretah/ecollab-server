class Label < ApplicationRecord
  has_many :attendances
  belongs_to :icon
end
