class ConvertJob < ApplicationJob
  queue_as :default

  def perform(upload_id)
    upload = Upload.find_by_id(upload_id)
    p upload
    p upload_id
    if !upload.blank?
      system("cd #{Rails.root}/public && mkdir #{upload.uuid}")
      system("cd #{Rails.root}/public/#{upload.uuid} && convert #{upload.attached_document_path} x-%04d.jpg")
      system("cd #{Rails.root}/public/#{upload.uuid} && convert *.jpg #{upload.uuid}.pdf")
      upload.converted =  true
      upload.save
    end
  end
end
