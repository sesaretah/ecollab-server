# == Schema Information
#
# Table name: exhibitions
#
#  id         :bigint           not null, primary key
#  title      :string
#  info       :string
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  is_active  :boolean
#
class ExhibitionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper
  attributes :id, :title, :info, :tags, :cover, :truncated_info,
             :is_admin, :attendees, :room_id, :room_uuid, :page, :pages,
             :is_active, :event_id

  belongs_to :event, serializer: EventIndexSerializer
  has_many :flyers, serializer: FlyerSerializer
  has_many :uploads, serializer: UploadSerializer
  has_many :questions, serializer: QuestionSerializer

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

  def attendees
    user_ids = object.attendances.pluck(:user_id)
    profiles = Profile.where("user_id in (?)", user_ids)
    return ActiveModel::SerializableResource.new(profiles, each_serializer: ProfileSerializer).as_json
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
