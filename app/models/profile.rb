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
class Profile < ApplicationRecord
  include Rails.application.routes.url_helpers
  require 'unicode_fixer'

  after_save ThinkingSphinx::RealTime.callback_for(:profile)
  belongs_to :user
  has_one_attached :avatar
  before_save :fix_unicode

  def nickname
    "#{self.name} #{self.surename}"
  end

  def tags
    return Tag.titler(self.user.tags)
  end

  def fix_unicode
    fixed_name = UnicodeFixer.fix(self.name)
    self.name = fixed_name
    fixed_surename = UnicodeFixer.fix(self.surename)
    self.surename = fixed_surename
  end

  def initials
    splited = self.name.split(" ")
    if splited.length > 1
      return "#{splited[0][0].capitalize}‌#{splited[1][0].capitalize}"
    else
      return "#{splited[0][0].capitalize}‌#{splited[0][1].capitalize}"
    end
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
