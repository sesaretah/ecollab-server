class MeetingSerializer < ActiveModel::Serializer
  attributes :id, :title, :start_time, :end_time,
             :capacity, :meeting_type, :info,
             :external_link, :attendees, :tags, :is_private, :room_id
  belongs_to :event, serializer: EventSerializer
  has_many :flyers, serializer: FlyerSerializer

  def attendees
    user_ids = object.attendances.pluck(:user_id)
    profiles = Profile.where("user_id in (?)", user_ids)
    return ActiveModel::SerializableResource.new(profiles, each_serializer: ProfileSerializer).as_json
  end

  def tags
    object.tags
  end

  def room_id
    object.room.id if !object.room.blank?
  end
end
