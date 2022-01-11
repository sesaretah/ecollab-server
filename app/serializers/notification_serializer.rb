# == Schema Information
#
# Table name: notifications
#
#  id                :bigint           not null, primary key
#  notifiable_id     :integer
#  notifiable_type   :string
#  source_user_id    :integer
#  target_user_ids   :json
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notification_type :string
#  seen              :boolean
#  status            :integer
#  custom_text       :string
#  target_user_hash  :json
#
class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :content, :profile, :target_type, :target_id, :seen,
              :notification_text

  def content
    case object.notification_type
    when  'Like'
      return "#{I18n.t(:like_notification)}"
    when  'Bookmark'
      return "#{I18n.t(:bookmark_notification)}" 
    when  'Follow'
      return "#{I18n.t(:follow_notification)}" 
    when  'Share'
      return "#{I18n.t(:share_notification)}" 
    end
  end

  def profile
    ProfileSerializer.new(object.user.profile).as_json
  end

  def target_type
    object.notifiable_type.tableize 
  end

  def target_id
    object.notifiable_id
  end

  def notification_text 
    if  !object.notifiable.blank?
      object.fcm_text(nil, object.notification_type, object.user.profile.fullname, object.notifiable.title, object.custom_text)
    end
  end
end
