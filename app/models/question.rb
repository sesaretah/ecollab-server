# == Schema Information
#
# Table name: questions
#
#  id                :bigint           not null, primary key
#  content           :string
#  questionable_type :string
#  questionable_id   :integer
#  user_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  is_private        :boolean
#
class Question < ApplicationRecord
  belongs_to :questionable, polymorphic: true

  belongs_to :user
  has_many :answers
end
