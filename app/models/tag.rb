class Tag < ApplicationRecord
  after_save ThinkingSphinx::RealTime.callback_for(:tag)
  has_many :taggings

  def self.titler(tags)
    result = []
    for tag in tags
      result << tag.title
    end
    return result
  end

  def self.top_used
    self
      .left_joins(:taggings)
      .group(:id)
      .order("COUNT(taggings.id) DESC")
  end

  def self.title_to_id(titles)
    result = []
    for title in titles
      tag = self.where(title: title).first
      result << tag.id if !tag.blank?
    end
    return result
  end
end
