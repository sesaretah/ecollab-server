# == Schema Information
#
# Table name: notification_settings
#
#  id                   :bigint           not null, primary key
#  user_id              :integer
#  notification_setting :json
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class NotificationSetting < ApplicationRecord
    belongs_to :user

    def add_notification_setting(item)
        self.notification_setting = {} if self.notification_setting.blank?
        self.notification_setting[item] = true
    end

    def remove_notification_setting(item)
        self.notification_setting = {} if self.notification_setting.blank?
        self.notification_setting[item] = false
    end

    def self.check(user_id, target, type)
        user = User.find_by_id(user_id)
        setting = user.notification_setting if !user.blank?
        if !setting.blank? && !setting.notification_setting.blank? && setting.notification_setting[target+type]
            return true
        else 
            return false
        end
    end

    def add_block_list(profile_id)
        profile = Profile.find_by_id(profile_id)
        self.blocked_list = [] if self.blocked_list.blank?
        self.blocked_list << profile.user_id if profile
    end

    def remove_block_list(profile_id)
        profile = Profile.find_by_id(profile_id)
        self.blocked_list = [] if self.blocked_list.blank?
        self.blocked_list.delete(profile.user_id) if profile
    end
end
