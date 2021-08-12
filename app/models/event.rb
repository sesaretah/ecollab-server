class Event < ApplicationRecord
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  has_many :attendances, as: :attendable, dependent: :destroy
  has_many :discussions, as: :discussable, dependent: :destroy
  has_many :flyers, as: :advertisable, dependent: :destroy
  has_many :uploads, as: :uploadable, dependent: :destroy

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :meetings, dependent: :destroy
  has_many :exhibitions, dependent: :destroy

  has_one_attached :cover_image
  #before_save :check_cropping

  def meeting_tags
    # tag_ids = Tagging.where("taggable_id in (?) and taggable_type = ?", self.meetings.pluck(:id), "Meeting").pluck(:tag_id)
    #return Tag.where("id in (?)", tag_ids.uniq)

    Tag
      .left_joins(:taggings)
      .where("taggable_id in (?) and taggable_type = ?", self.meetings.pluck(:id), "Meeting")
      .group(:id)
      .order("COUNT(taggings.id) DESC")
  end

  def check_cropping
    self.crop_settings = { x: crop_x, y: crop_y, w: crop_w, h: crop_h } if cropping?
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def cropped_image
    if cover_image.attached?
      if crop_settings.is_a? Hash
        dimensions = "#{crop_settings["w"]}x#{crop_settings["h"]}"
        coord = "#{crop_settings["x"]}+#{crop_settings["y"]}"
        cover_image.variant(
          crop: "#{dimensions}+#{coord}",
        ).processed
      else
        cover_image
      end
    end
  end

  def thumbnail(size = "100x100")
    if cover_image.attached?
      if crop_settings.is_a? Hash
        dimensions = "#{crop_settings["w"]}x#{crop_settings["h"]}"
        coord = "#{crop_settings["x"]}+#{crop_settings["y"]}"
        cover_image.variant(
          crop: "#{dimensions}+#{coord}",
          resize: size,
        ).processed
      else
        cover_image.variant(resize: size).processed
      end
    end
  end
end
