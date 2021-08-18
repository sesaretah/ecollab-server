class Exhibition < ApplicationRecord
  after_save ThinkingSphinx::RealTime.callback_for(:exhibition)
  has_many :flyers, as: :advertisable, dependent: :destroy
  has_many :uploads, as: :uploadable, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :attendances, as: :attendable, dependent: :destroy
  has_many :questions, as: :questionable, dependent: :destroy

  has_many :tags, through: :taggings

  belongs_to :event, optional: true

  has_one :room, dependent: :destroy

  after_create :add_admin
  after_create :setup_room

  def setup_room
    Room.create(title: self.title, is_private: false, exhibition_id: self.id, moderator_ids: [self.user_id])
  end

  def add_admin
    Attendance.create(attendable_id: self.id, attendable_type: "Exhibition", user_id: self.user_id, duty: "moderator")
  end

  def is_admin(user_id)
    Attendance.where(attendable_id: self.id, attendable_type: "Exhibition", user_id: user_id, duty: "moderator").any?
  end
end
