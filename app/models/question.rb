class Question < ApplicationRecord
  belongs_to :questionable, polymorphic: true

  belongs_to :user
  has_many :answers
end
