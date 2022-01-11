# == Schema Information
#
# Table name: meetings
#
#  id                      :bigint           not null, primary key
#  title                   :string
#  info                    :text
#  event_id                :integer
#  meeting_type            :string
#  start_time              :datetime
#  end_time                :datetime
#  location                :string
#  is_private              :boolean
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  capacity                :integer
#  external_link           :string
#  user_id                 :integer
#  internal                :boolean
#  bigblue                 :boolean
#  sata                    :boolean
#  sata_displays           :json
#  per_display             :integer
#  number_of_sata_displays :integer
#
class MeetingSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper
  attributes :id, :title, :start_time, :end_time,
             :capacity, :meeting_type, :info,
             :external_link, :attendees, :tags, :is_private, :room_id,
             :start_day, :end_day, :cover, :truncated_info, :is_admin,
             :room_uuid, :page, :pages, :attending,
             :internal, :bigblue, :sata, :is_presenter,
             :is_moderator, :is_speaker, :attendees_count,
             :number_of_sata_displays, :per_display, :bigblue_recordings
  belongs_to :event, serializer: EventIndexSerializer
  has_many :flyers, serializer: FlyerSerializer
  has_many :uploads, serializer: UploadSerializer

  def attendees
    user_ids = object.attendances.limit(10).pluck(:user_id)
    profiles = Profile.where("user_id in (?)", user_ids)
    return ActiveModel::SerializableResource.new(profiles, each_serializer: ProfileSerializer).as_json
  end

  def bigblue_recordings
    BigBlue::Recordings.new(room: object.room) if !object.room.blank?
  end

  def attendees_count
    object.attendances.count
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

  def room_id
    object.room.id if !object.room.blank?
  end

  def room_uuid
    object.room.uuid if !object.room.blank?
  end

  def start_day
    #We should internationalize this, for now lets focus on Tehran
    object.start_time.in_time_zone("Tehran").beginning_of_day
  end

  def end_day
    #We should internationalize this, for now lets focus on Tehran
    object.end_time.in_time_zone("Tehran").end_of_day
  end

  def truncated_info
    truncate(object.info, :length => 200)
  end

  def is_admin
    if scope && scope[:user_id]
      user = User.find_by_id(scope[:user_id])
      if !user.blank? && !user.ability.blank? && user.ability.administration
        return true
      end
    end

    if scope && scope[:user_id]
      user = User.find_by_id(scope[:user_id])
      if !user.blank? && object.event.is_admin(scope[:user_id])
        return true
      end
    end

    if scope && scope[:user_id] && object.is_admin(scope[:user_id])
      return true
    else
      return false
    end
  end

  def is_presenter
    if scope && scope[:user_id]
      object.attendances.where(duty: "presenter", user_id: scope[:user_id]).any?
    end
  end

  def is_moderator
    if scope && scope[:user_id]
      user = User.find_by_id(scope[:user_id])
      if !user.blank? && !user.ability.blank? && user.ability.administration
        return true
      end
    end

    if scope && scope[:user_id]
      object.attendances.where(duty: "moderator", user_id: scope[:user_id]).any?
    end
  end

  def is_speaker
    if scope && scope[:user_id]
      object.attendances.where(duty: "speaker", user_id: scope[:user_id]).any?
    end
  end

  def attending
    if scope && scope[:user_id]
      user = User.find_by_id(scope[:user_id])
      if !user.blank? && !user.ability.blank? && user.ability.administration
        return true
      end
    end

    if scope && scope[:user_id] && object.is_attending(scope[:user_id])
      return true
    else
      return false
    end
  end
end
