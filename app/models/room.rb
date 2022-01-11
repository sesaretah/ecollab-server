# == Schema Information
#
# Table name: rooms
#
#  id                 :bigint           not null, primary key
#  title              :string
#  is_private         :boolean
#  uuid               :string
#  secret             :string
#  pin                :string
#  activated          :boolean
#  moderator_ids      :json
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  meeting_id         :integer
#  vuuid              :string
#  vpin               :string
#  vsecret            :string
#  exhibition_id      :integer
#  attendee_password  :string
#  moderator_password :string
#
class Room < ApplicationRecord
  before_create :set_uuid

  after_create :setup_janus
  before_destroy :destroy_janus

  belongs_to :meeting, optional: true
  belongs_to :exhibition, optional: true

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

  def ref_class
    if !self.meeting_id.blank?
      return self.meeting
    else
      return self.exhibition
    end
  end
end
