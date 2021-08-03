class Tag < ApplicationRecord
  after_save ThinkingSphinx::RealTime.callback_for(:tag)

  def self.titler(tags)
    result = []
    for tag in tags
      result << tag.title
    end
    return result
  end
end
