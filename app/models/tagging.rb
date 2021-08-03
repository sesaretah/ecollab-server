class Tagging < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  belongs_to :tag

  def self.extract_tags(tag_titles, taggable_type, taggable_id)
    Tagging.where(taggable_type: taggable_type, taggable_id: taggable_id).destroy_all
    if !tag_titles.blank?
      for title in tag_titles
        tag = Tag.where(title: title).first
        if tag.blank?
         tag = Tag.create(title: title)
        end
        Tagging.create(tag_id: tag.id, taggable_type: taggable_type, taggable_id: taggable_id)
      end
    end
  end
end
