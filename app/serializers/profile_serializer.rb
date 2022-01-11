# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  name       :string
#  surename   :string
#  mobile     :string
#  bio        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  faculty    :string
#  privacy    :json
#  country    :string
#  twitter    :string
#  linkdin    :string
#  email      :string
#  instagram  :string
#  telegram   :string
#  phone      :string
#
class ProfileSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper

  attributes :id, :name, :surename, :fullname, :bio,
             :twitter, :instagram, :telegram, :phone, :linkdin, :email,
             :avatar, :last_login, :editable, :country, :initials, :tags,
             :user_id, :short_bio, :tags, :abilities, :page, :pages, :cover,
             :uuid

  belongs_to :user

  def uuid
    object.user.uuid if !object.user.blank?
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

  def cover
    upload = Upload.where("uploadable_type = ? and uploadable_id = ? and upload_type = ?", "Profile", object.id, "avatar").last
    if !upload.blank? && upload.attached_document.attached? && !upload.crop_settings.blank?
      dimensions = "#{upload.crop_settings["width"]}x#{upload.crop_settings["height"]}"
      coord = "#{upload.crop_settings["x"]}+#{upload.crop_settings["y"]}"
      Rails.application.routes.default_url_options[:host] + rails_representation_url(upload.attached_document.variant(
        crop: "#{dimensions}+#{coord}",
      ).processed, only_path: true)
    else
      Rails.application.routes.default_url_options[:host] + "/empty.png"
    end
  end
end
