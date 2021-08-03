class Event < ApplicationRecord
  has_many :attendances, as: :attendable
  has_many :discussions, as: :discussable
  has_many :flyers, as: :advertisable

  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings

  has_many :meetings
end
