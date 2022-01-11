# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  title         :string
#  event_type    :string
#  info          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#  is_private    :boolean
#  crop_settings :json
#  start_date    :date
#  end_date      :date
#  shortname     :string
#
class EventSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper
  attributes :id, :title, :info, :event_type,
             :attendees, :tags, :is_private, :shortname,
             :cover, :start_date, :end_date, :truncated_info,
             :is_admin, :page, :pages, :attending, :meetings, :attendees_count

  has_many :flyers, serializer: FlyerSerializer
  has_many :uploads, serializer: UploadSerializer

  def attendees
    user_ids = object.attendances.limit(10).pluck(:user_id)
    profiles = Profile.where("user_id in (?)", user_ids)
    return ActiveModel::SerializableResource.new(profiles, each_serializer: ProfileSerializer).as_json
  end

  def attendees_count
    object.attendances.count
  end

  def meetings
    today = DateTime.current.beginning_of_day
    meetings = object.meetings.where("(start_time <= ? and end_time >= ?) or start_time >= ?", today, today, today).order("start_time").limit(5)
    if meetings.blank?
      meetings = object.meetings.order("start_time desc").limit(5)
    end
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
