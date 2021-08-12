class Upload < ApplicationRecord
  belongs_to :uploadable, polymorphic: true, optional: true
  has_one_attached :attached_document
  before_create :assign_uuid
  # after_commit :prepare_pdf, on: :create
  belongs_to :user, optional: true

  def assign_uuid
    self.uuid = SecureRandom.hex(6)
  end

  def attached_document_path
    ActiveStorage::Blob.service.path_for(attached_document.key)
  end

  #def prepare_pdf
  #  ConvertJob.perform_later(self.id)
  #end

  def check_cropping
    self.crop_settings = { x: crop_x, y: crop_y, w: crop_w, h: crop_h } if cropping?
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
