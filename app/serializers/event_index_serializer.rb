class EventIndexSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper
  attributes :id, :title, :info, :event_type,
             :tags, :is_private, :shortname,
             :cover, :start_date, :end_date, :truncated_info,
             :is_admin, :page, :pages, :attending
  #has_many :meetings, serializer: MeetingSerializer
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
