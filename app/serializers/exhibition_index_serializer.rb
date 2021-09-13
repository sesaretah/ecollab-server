class ExhibitionIndexSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper
  attributes :id, :title, :info, :tags, :cover, :truncated_info,
             :is_admin, :room_id, :room_uuid, :page, :pages, :is_active

  belongs_to :event, serializer: EventIndexSerializer

  def tags
    object.tags
  end

  def page
    if scope && scope[:page]
      scope[:page]
    end
  end

  def pages
    if scope && scope[:pages]
      scope[:pages]
    end
  end

  def truncated_info
    truncate(object.info, :length => 200)
  end

  def room_id
    object.room.id if !object.room.blank?
  end

  def room_uuid
    object.room.uuid if !object.room.blank?
  end

  def cover
    upload = Upload.where("uploadable_type = ? and uploadable_id = ? and upload_type = ?", "Exhibition", object.id, "cover").last
    if !upload.blank? && upload.attached_document.attached? && !upload.crop_settings.blank?
      dimensions = "#{upload.crop_settings["width"]}x#{upload.crop_settings["height"]}"
      coord = "#{upload.crop_settings["x"]}+#{upload.crop_settings["y"]}"
      Rails.application.routes.default_url_options[:host] + rails_representation_url(upload.attached_document.variant(
        crop: "#{dimensions}+#{coord}",
      ).processed, only_path: true)
    end
  end

  def is_admin
    if scope && scope[:user_id]
      user = User.find_by_id(scope[:user_id])
      if !user.blank? && !user.ability.blank? && user.ability.administration
        return true
      end
    end

    if scope && scope[:user_id] && object.is_admin(scope[:user_id])
      return true
    else
      return false
    end
  end
end
