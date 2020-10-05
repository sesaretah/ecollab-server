class UploadSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :link, :uuid, :converted, :converted_link

  def link
    if object.attached_document.attached?
      Rails.application.routes.default_url_options[:host] + rails_blob_url(object.attached_document, only_path: true)
    end
  end

  def converted_link
    if object.converted
      Rails.application.routes.default_url_options[:host] + "v1/download/#{object.uuid}.pdf"
    end
  end
end
