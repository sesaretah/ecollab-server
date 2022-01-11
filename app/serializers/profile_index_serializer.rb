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
class ProfileIndexSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper

  attributes :id, :name, :surename, :fullname, :bio, :initials,
             :user_id, :abilities, :uuid, :cover

  belongs_to :user

  def uuid
    object.user.uuid if !object.user.blank?
  end

  def abilities
    ability = object.user.ability
    if !ability.blank?
      return ability
    end
  end

  def initials
    object.initials
  end

  def last_login
    object.user.last_login
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
