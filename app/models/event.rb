class Event < ApplicationRecord
  after_save ThinkingSphinx::RealTime.callback_for(:event)

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
    Event
      .left_joins(:attendances)
      .where("attendable_type = ? and attendances.user_id = ? and duty = ?", "Event", user_id, "moderator")
  end

  def is_attending(user_id)
    Attendance.where("attendable_id = ? and attendable_type = ? and user_id = ?", self.id, "Event", user_id).any?
  end

  def self.date_range(s, e)
    from = Time.at(s.to_i / 1000).to_datetime.beginning_of_day
    to = Time.at(e.to_i / 1000).to_datetime.beginning_of_day
    return self.where("(start_date between ? and ?) OR (end_date between ? and ?) OR (start_date <= ? and end_date >= ?)", from, to, from, to, from, to).pluck(:id)
  end
end
