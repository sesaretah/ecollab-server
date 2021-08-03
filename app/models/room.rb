class Room < ApplicationRecord
  before_create :set_uuid
  #before_save :set_title
  after_create :setup_janus
  before_destroy :destroy_janus

  # has_many :users, through: :participations
  # has_many :participations
  belongs_to :meeting

  def set_uuid
    self.uuid = SecureRandom.random_number(10000000)
    self.pin = SecureRandom.hex(10)
    self.secret = SecureRandom.hex(10)

    self.vuuid = SecureRandom.random_number(10000000)
    self.vpin = SecureRandom.hex(10)
    self.vsecret = SecureRandom.hex(10)
  end

  def set_title
    self.title = self.meeting.title
  end

  def setup_janus
    RoomCreateJob.perform_later(self.id)
    VideoroomCreateJob.perform_later(self.id)
  end

  def destroy_janus
    RoomDestroyJob.perform_later(self.uuid, self.secret)
  end
end
