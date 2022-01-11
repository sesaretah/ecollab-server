# == Schema Information
#
# Table name: attendances
#
#  id              :bigint           not null, primary key
#  user_id         :integer
#  attendable_id   :integer
#  attendable_type :string
#  label_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  role_id         :integer
#  duty            :string
#
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
    self.user.profile if !self.user.blank? && !self.user.profile.blank?
  end

  def user_attendances(user:, klass:)
  end

  def attendable_owner
    attendable = self.attendable_type.classify.constantize.find(self.attendable_id)
    if !attendable.blank? && attendable.user_id != self.user_id
      true
    else
      false
    end
  end
end
