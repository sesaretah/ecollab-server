# == Schema Information
#
# Table name: uploads
#
#  id              :bigint           not null, primary key
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  uuid            :string
#  converted       :boolean
#  user_id         :integer
#  uploadable_type :string
#  uploadable_id   :integer
#  upload_type     :string
#  is_private      :boolean
#  crop_settings   :json
#
class Upload < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :uploadable, polymorphic: true, optional: true
  has_one_attached :attached_document
  before_create :assign_uuid

  belongs_to :user, optional: true

  def assign_uuid
    self.uuid = SecureRandom.hex(6)
  end

  def attached_document_path
    ActiveStorage::Blob.service.path_for(attached_document.key)
  end

  def check_cropping
    self.crop_settings = { x: crop_x, y: crop_y, w: crop_w, h: crop_h } if cropping?
  end

  def cropped_url
    if self.attached_document.attached? && !self.crop_settings.blank?
      dimensions = "#{self.crop_settings["width"]}x#{self.crop_settings["height"]}"
      coord = "#{self.crop_settings["x"]}+#{self.crop_settings["y"]}"
      Rails.application.routes.default_url_options[:host] + rails_representation_url(self.attached_document.variant(
        crop: "#{dimensions}+#{coord}",
      ).processed, only_path: true)
    end
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def cropped_image
    if attached_document.attached?
      if crop_settings.is_a? Hash
        dimensions = "#{crop_settings["w"]}x#{crop_settings["h"]}"
        coord = "#{crop_settings["x"]}+#{crop_settings["y"]}"
        attached_document.variant(
          crop: "#{dimensions}+#{coord}",
        ).processed
      else
        attached_document
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
