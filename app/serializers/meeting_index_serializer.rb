class MeetingIndexSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper
  attributes :id, :title, :start_time, :end_time,
             :capacity, :meeting_type, :info,
             :external_link, :tags, :is_private, :room_id,
             :start_day, :end_day, :cover, :truncated_info, :is_admin,
             :room_uuid, :page, :pages, :attending
  #belongs_to :event, serializer: EventSerializer
  #has_many :flyers, serializer: FlyerSerializer
  #has_many :uploads, serializer: UploadSerializer

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

  def tags
    object.tags
  end

  def room_id
    object.room.id if !object.room.blank?
  end

  def room_uuid
    object.room.uuid if !object.room.blank?
  end

  def start_day
    object.start_time.in_time_zone("Tehran").beginning_of_day
  end

  def end_day
    object.end_time.in_time_zone("Tehran").end_of_day
  end

  def truncated_info
    truncate(object.info, :length => 200)
  end

  def cover
    upload = Upload.where("uploadable_type = ? and uploadable_id = ? and upload_type = ? ", "Meeting", object.id, "cover").last
    if !upload.blank? && upload.attached_document.attached? && !upload.crop_settings.blank?
      dimensions = "#{upload.crop_settings["width"]}x#{upload.crop_settings["height"]}"
      coord = "#{upload.crop_settings["x"]}+#{upload.crop_settings["y"]}"
      Rails.application.routes.default_url_options[:host] + rails_representation_url(upload.attached_document.variant(
        crop: "#{dimensions}+#{coord}", resize: "440x440",
      ).processed, only_path: true)
    end
  end

  def is_admin
    if scope && scope[:user_id] && object.is_admin(scope[:user_id])
      return true
    else
      return false
    end
  end

  def attending
    if scope && scope[:user_id] && object.is_attending(scope[:user_id])
      return true
    else
      return false
    end
  end
end
