class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :info, :event_type, :attendees, :tags, :is_private
  has_many :meetings, serializer: MeetingSerializer
  has_many :flyers, serializer: FlyerSerializer

  def attendees
    user_ids = object.attendances.pluck(:user_id)
    profiles = Profile.where("user_id in (?)", user_ids)
    return ActiveModel::SerializableResource.new(profiles, each_serializer: ProfileSerializer).as_json
  end

  def tags
    object.tags
  end
end
