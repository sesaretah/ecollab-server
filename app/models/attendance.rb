class Attendance < ApplicationRecord
  belongs_to :attendable, polymorphic: true
  belongs_to :label, optional: true
  belongs_to :user

  before_save :check_for_duplicates?

  def check_for_duplicates?
    if self.id.blank? && Attendance.where(attendable_id: self.attendable_id, attendable_type: self.attendable_type, user_id: self.user_id).any?
      raise "Duplicate"
    end
  end

  def profile
    self.user.profile
  end
end
