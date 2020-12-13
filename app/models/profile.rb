class Profile < ApplicationRecord
  include Rails.application.routes.url_helpers
  after_save ThinkingSphinx::RealTime.callback_for(:profile)
  belongs_to :user
  has_one_attached :avatar

  def nickname
    "#{self.name} #{self.surename}"
  end

  def fullname
    self.nickname
  end

  def title
    self.fullname
  end

  def profile_avatar
    if self.avatar.attached?
      Rails.application.routes.default_url_options[:host] + rails_blob_url(self.avatar, only_path: true)
    else
      Rails.application.routes.default_url_options[:host] + "/images/default.png"
    end
  end

end
