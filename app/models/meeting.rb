class Meeting < ApplicationRecord
  after_create :setup_room

  has_many :attendances, as: :attendable
  has_many :discussions, as: :discussable
  has_many :flyers, as: :advertisable

  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings

  has_one :room

  belongs_to :event

  def setup_room
    Room.create(title: self.title, is_private: self.is_private, meeting_id: self.id, moderator_ids: [self.user_id])
  end
end
