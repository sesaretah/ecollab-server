class Participation < ApplicationRecord
    belongs_to :user
    belongs_to :room

    before_create :assign_uuid
  
    def assign_uuid
      self.uuid = SecureRandom.uuid
    end

    def add_activity(activity)
        self.activity_logs = [] if self.activity_logs.blank?
        self.activity_logs << {title: activity, performed_at: DateTime.now}
    end

end
