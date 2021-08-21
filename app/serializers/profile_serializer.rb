class ProfileSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper

  attributes :id, :name, :surename, :fullname, :bio,
             :avatar, :last_login, :editable, :country, :initials, :tags,
             :user_id, :short_bio, :tags, :abilities

  belongs_to :user

  def tags
    object.user.tags
  end

  def abilities
    ability = object.user.ability
    if !ability.blank?
      return ability
    end
  end

  def short_bio
    truncate(object.bio, :length => 40)
  end

  def editable
    if scope && scope[:user_id] && object.user_id == scope[:user_id]
      return true
    else
      return false
    end
  end

  def initials
    object.initials
  end

  def last_login
    object.user.last_login
  end

  def bio
    if object.bio.blank?
      return ""
    else
      object.bio
    end
  end

  def avatar
    object.profile_avatar
  end
end
