# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  title         :string
#  event_type    :string
#  info          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#  is_private    :boolean
#  crop_settings :json
#  start_date    :date
#  end_date      :date
#  shortname     :string
#
class Event < ApplicationRecord
  after_save ThinkingSphinx::RealTime.callback_for(:event), unless: :skip_callbacks

  has_many :attendances, as: :attendable, dependent: :destroy
  has_many :discussions, as: :discussable, dependent: :destroy
  has_many :flyers, as: :advertisable, dependent: :destroy
  has_many :uploads, as: :uploadable, dependent: :destroy

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :meetings, dependent: :destroy
  has_many :exhibitions, dependent: :destroy
  after_create :add_admin

  def add_admin
    Attendance.create(attendable_id: self.id, attendable_type: "Event", user_id: self.user_id, duty: "moderator")
  end

  def is_admin(user_id)
    Attendance.where(attendable_id: self.id, attendable_type: "Event", user_id: user_id, duty: "moderator").any?
  end

  def meeting_tags
    Tag
      .left_joins(:taggings)
      .where("taggable_id in (?) and taggable_type = ?", self.meetings.pluck(:id), "Meeting")
      .group(:id)
      .order("COUNT(taggings.id) DESC")
  end

  def self.owner(user_id)
    self
      .left_joins(:attendances)
      .where("attendable_type = ? and attendances.user_id = ? and duty = ?", "Event", user_id, "moderator")
  end

  def is_attending(user_id)
    Attendance.where("attendable_id = ? and attendable_type = ? and user_id = ?", self.id, "Event", user_id).any?
  end

  def self.related(user_id)
    self
      .left_joins(:attendances)
      .where("attendable_type = ? and attendances.user_id = ?", "Event", user_id)
  end

  def cover
    upload = Upload.where("uploadable_type = ? and uploadable_id = ? and upload_type = ?", "Event", self.id, "cover").last
    return upload.cropped_url if !upload.blank?
  end
end
