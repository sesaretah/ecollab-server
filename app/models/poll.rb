# == Schema Information
#
# Table name: polls
#
#  id             :bigint           not null, primary key
#  pollable_id    :integer
#  pollable_type  :string
#  content        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  answer_type    :string
#  answer_content :json
#  user_id        :integer
#
class Poll < ApplicationRecord
  belongs_to :pollable, polymorphic: true
  has_many :pollings, dependent: :destroy

  before_save :extract_answer_content

  def extract_answer_content
    if self.answer_type == "single_select" || self.answer_type == "multiple_select"
      temp = self.answer_content.split("\n")
      self.answer_content = temp
    else
      self.answer_content = []
    end
  end
end
