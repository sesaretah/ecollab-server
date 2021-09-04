class RoomSerializer < ActiveModel::Serializer
  attributes :id, :title, :is_private, :uuid, :pin, :user_uuid, :user_fullname,
             :is_owner, :is_admin, :vuuid, :vpin, :secret, :vsecret, :is_presenter,
             :is_moderator, :is_speaker, :is_sata

  def user_uuid
    if scope && scope[:user_id]
      user = User.find_by_id(scope[:user_id])
      user.uuid if !user.blank?
    end
  end

  def is_sata
    object.meeting.sata if object.meeting
  end

  def user_fullname
    if scope && scope[:user_id]
      user = User.find_by_id(scope[:user_id])
      user.profile.fullname if !user.blank? && !user.profile.blank?
    end
  end

  def is_owner
    if scope && scope[:user_id] && object.ref_class.user_id == scope[:user_id]
      true
    else
      false
    end
  end

  def is_presenter
    if scope && scope[:user_id]
      object.ref_class.attendances.where(duty: "presenter", user_id: scope[:user_id]).any?
    end
  end

  def is_moderator
    if scope && scope[:user_id]
      object.ref_class.attendances.where(duty: "moderator", user_id: scope[:user_id]).any?
    end
  end

  def is_speaker
    if scope && scope[:user_id]
      object.ref_class.attendances.where(duty: "speaker", user_id: scope[:user_id]).any?
    end
  end

  def is_admin
    if scope && scope[:user_id] && !object.moderator_ids.blank? && object.moderator_ids.include?(scope[:user_id].to_i)
      true
    else
      false
    end
  end
end
