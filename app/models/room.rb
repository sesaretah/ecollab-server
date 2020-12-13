class Room < ApplicationRecord
    before_create :set_uuid
    after_create :setup_janus
    before_destroy :destroy_janus

    has_many :users, through: :participations
    has_many :participations

    def set_uuid
      self.uuid = SecureRandom.random_number(10000000) 
      self.pin = SecureRandom.hex(10) 
      self.secret = SecureRandom.hex(10) 
    end
    
    def setup_janus
      RoomCreateJob.perform_later(self.id)
    end

    def destroy_janus
      RoomDestroyJob.perform_later(self.uuid, self.secret)
    end
end
