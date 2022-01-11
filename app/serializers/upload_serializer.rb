# == Schema Information
#
# Table name: uploads
#
#  id              :bigint           not null, primary key
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  uuid            :string
#  converted       :boolean
#  user_id         :integer
#  uploadable_type :string
#  uploadable_id   :integer
#  upload_type     :string
#  is_private      :boolean
#  crop_settings   :json
#
class UploadSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :upload_type, :is_private, :link, :uuid,
             :cropped, :converted, :converted_link, :uploader,
             :uploadable_link

  def link
    if object.attached_document.attached?
      Rails.application.routes.default_url_options[:host] + rails_blob_url(object.attached_document, only_path: true)
    end
  end

  def cropped
    if object.attached_document.attached? && !object.crop_settings.blank?
      dimensions = "#{object.crop_settings["width"]}x#{object.crop_settings["height"]}"
      coord = "#{object.crop_settings["x"]}+#{object.crop_settings["y"]}"
      Rails.application.routes.default_url_options[:host] + rails_representation_url(object.attached_document.variant(
        crop: "#{dimensions}+#{coord}",
      ).processed, only_path: true)
    end
  end

  def uploader
    object.user.profile.name
  end

  def converted_link
    if object.converted
      Rails.application.routes.default_url_options[:host] + "v1/download/#{object.uuid}.pdf"
    end
  end

  def uploadable_link
    if !object.uploadable_type.blank? && !object.uploadable_id.blank?
      "#{object.uploadable_type.underscore.pluralize}/#{object.uploadable_id}"
    end
  end
end
