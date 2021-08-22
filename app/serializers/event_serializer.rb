class EventSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper
  attributes :id, :title, :info, :event_type,
             :attendees, :tags, :is_private,
             :cover, :start_date, :end_date, :truncated_info,
             :is_admin, :page, :pages, :attending, :meetings
  #has_many :meetings, serializer: MeetingIndexSerializer
  has_many :flyers, serializer: FlyerSerializer
  has_many :uploads, serializer: UploadSerializer

  def attendees
    user_ids = object.attendances.pluck(:user_id)
    profiles = Profile.where("user_id in (?)", user_ids)
    return ActiveModel::SerializableResource.new(profiles, each_serializer: ProfileSerializer).as_json
  end

  def meetings
    today = DateTime.current.beginning_of_day
    meetings = object.meetings.where("(start_time <= ? and end_time >= ?) or start_time >= ?", today, today, today).order("start_time").limit(5)
    return ActiveModel::SerializableResource.new(meetings, scope: { user_id: scope[:user_id] }, each_serializer: MeetingIndexSerializer).as_json
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

  def tags
    object.tags
  end

  def truncated_info
    truncate(object.info, :length => 200)
  end

  def cover
    upload = Upload.where("uploadable_type = ? and uploadable_id = ? and upload_type = ?", "Event", object.id, "cover").last
    if !upload.blank? && upload.attached_document.attached? && !upload.crop_settings.blank?
      dimensions = "#{upload.crop_settings["width"]}x#{upload.crop_settings["height"]}"
      coord = "#{upload.crop_settings["x"]}+#{upload.crop_settings["y"]}"
      Rails.application.routes.default_url_options[:host] + rails_representation_url(upload.attached_document.variant(
        crop: "#{dimensions}+#{coord}",
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
