module Extractor
  class TaggingExtractor
    def initialize(titles:, taggable:)
      @titles = titles
      @taggable_type = taggable.class.name
      @taggable_id = taggable.id
    end

    def call
      destroy_legacy
      extract_from_titles
    end

    private

    def destroy_legacy
      Tagging.where(taggable_type: @taggable_type, taggable_id: @taggable_id).destroy_all
    end

    def extract_from_titles
      if !@titles.blank?
        for title in @titles
          tag = exist?(title)
          create_tagging(tag)
        end
      end
    end

    def create_tagging(tag)
      Tagging.create(tag_id: tag.id, taggable_type: @taggable_type, taggable_id: @taggable_id)
    end

    def exist?(title)
      Tag.find_or_create_by(title: title)
    end
  end
end
