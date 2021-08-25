class Poll < ApplicationRecord
  belongs_to :pollable, polymorphic: true
  has_many :pollings

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
