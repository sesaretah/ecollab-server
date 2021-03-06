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
class NotificationSettingSerializer < ActiveModel::Serializer
  attributes :id, :notification_setting
  belongs_to :user

end
