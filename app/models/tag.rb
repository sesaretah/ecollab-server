# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  after_save ThinkingSphinx::RealTime.callback_for(:tag)

  has_many :taggings

  def self.top_used
    self
      .left_joins(:taggings)
      .group(:id)
      .order("COUNT(taggings.id) DESC")
  end
end
