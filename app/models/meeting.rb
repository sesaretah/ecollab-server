class Meeting < ApplicationRecord
  after_save ThinkingSphinx::RealTime.callback_for(:meeting)
  after_create :setup_room

  has_many :attendances, as: :attendable, dependent: :destroy
  has_many :discussions, as: :discussable, dependent: :destroy
  has_many :flyers, as: :advertisable, dependent: :destroy
  has_many :uploads, as: :uploadable, dependent: :destroy

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  has_one :room, dependent: :destroy

  belongs_to :event

  after_create :add_admin

  def setup_room
    Room.create(title: self.title, is_private: self.is_private, meeting_id: self.id, moderator_ids: [self.user_id])
  end

  def add_admin
    Attendance.create(attendable_id: self.id, attendable_type: "Meeting", user_id: self.user_id, duty: "moderator")
  end

  def is_admin(user_id)
    Attendance.where(attendable_id: self.id, attendable_type: "Meeting", user_id: user_id, duty: "moderator").any?
  end

  def is_presenter(user_id)
    Attendance.where("attendable_id = ? and attendable_type = ? and user_id = ? and duty in (?)", self.id, "Meeting", user_id, ["moderator", "presenter"]).any?
  end

  def user_duty(user_id)
    attendance = Attendance.where("attendable_id = ? and attendable_type = ? and user_id = ?", self.id, "Meeting", user_id).last
    if !attendance.blank?
      return attendance.duty
    else
      return "listener"
    end
  end

  def is_attending(user_id)
    Attendance.where("attendable_id = ? and attendable_type = ? and user_id = ?", self.id, "Meeting", user_id).any?
  end

  def self.date_range(s, e)
    from = Time.at(s.to_i / 1000).to_datetime
    to = Time.at(e.to_i / 1000).to_datetime
    return self.where("(start_time between ? and ?) OR (end_time between ? and ?) OR (start_time <= ? and end_time >= ?)", from, to, from, to, from, to).pluck(:id)
  end
end
