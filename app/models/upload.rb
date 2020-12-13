class Upload < ApplicationRecord
  has_one_attached :attached_document
  before_create :assign_uuid
  after_commit :prepare_pdf, on: :create
  belongs_to :user

  def assign_uuid
    self.uuid = SecureRandom.hex(6)
  end

  def attached_document_path
    ActiveStorage::Blob.service.path_for(attached_document.key)
  end

  def prepare_pdf
    ConvertJob.perform_later(self.id)
  end

end
