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
class Notification < ApplicationRecord
    # belongs_to :notifiable, :polymorphic => true
    # #belongs_to :user
    # after_create :notify_by_mail

    # def self.seen_list(notifications)
    #     for notification in notifications
    #         notification.seen = true
    #         notification.save
    #     end
    #     return true
    # end

    # def notify_by_mail
    #     for target_user_id in self.target_user_ids
    #         NotificationsMailer.notify_email(target_user_id, self.notification_type, self.user.profile.fullname, self.notifiable.title).deliver_later
    #     end
    # end

    # def user
    #     User.find_by_id(self.source_user_id) if self.source_user_id
    # end

    include ActionView::Helpers::TextHelper
    belongs_to :notifiable, :polymorphic => true
    #belongs_to :user
    after_create :notify_by_fcm
    after_create :notify_by_mail
    after_create :fix_target_user_hash
    

    def self.seen_list(notifications)
        for notification in notifications
            notification.seen = true
            notification.save
        end
        return true
    end

    def notify_by_mail
        for target_user_id in self.target_user_ids.uniq
            if NotificationSetting.check(target_user_id, Notification.notification_type_eql(self.notification_type, self.notifiable.class.name),'email')
                NotificationsMailer.notify_email(target_user_id, self.notification_type, self.user.profile.fullname, self.notifiable.title, self.custom_text, self.notifiable.id, self.notifiable.class.name.downcase.pluralize).deliver_later
            end
        end
    end


    def notify_by_fcm
        for target_user_id in self.target_user_ids.uniq
            if NotificationSetting.check(target_user_id, Notification.notification_type_eql(self.notification_type, self.notifiable.class.name),'push')
                target_user = User.find_by_id(target_user_id)
                token = target_user.devices.last.token if target_user && target_user.devices && target_user.devices.last
                fcm_text = fcm_text(target_user_id, self.notification_type, self.user.profile.fullname, self.notifiable.title, self.custom_text)
                FcmJob.perform_later(fcm_text[:title], fcm_text[:body], token) if token
            end
        end
    end

    def fcm_text(user_id, notify_type, notifier, notify_text, custom_text, auxiliary_custom_text=nil)
        case notify_type
        when  'Like'
            title = "#{I18n.t(:like_notification)} #{I18n.t(:via)} #{notifier} #{I18n.t(:onto)} #{notify_text}"
            body =  "#{truncate(custom_text)}"
        when  'Share'
            title = "#{I18n.t(:share_notification)}  #{I18n.t(:via)} #{notifier} #{I18n.t(:onto)} #{notify_text}" 
            body =  "#{truncate(custom_text)}"
        when  'Follow'
            title = "#{I18n.t(:follow_notification)}  #{I18n.t(:via)} #{notifier} #{I18n.t(:onto)} #{notify_text}" 
            body =  "#{truncate(custom_text)}"
        when  'Bookmark'
            title = "#{I18n.t(:bookmark_notification)}  #{I18n.t(:via)} #{notifier} #{I18n.t(:onto)} #{notify_text}" 
            body =  "#{truncate(custom_text)}"
        when  'Comment'
            title = "#{I18n.t(:comment_notification)}  #{I18n.t(:via)} #{notifier} #{I18n.t(:onto)} #{notify_text}" 
            body =  "#{truncate(custom_text)}"
        when  'FollowedComment'
            title = "#{I18n.t(:comment_notification)}  #{I18n.t(:via)} #{notifier} #{I18n.t(:onto)} #{notify_text}" 
            body =  "#{truncate(custom_text)}"
        when  'Post'
            title = "#{I18n.t(:post_notification)}  #{I18n.t(:via)} #{notifier} #{I18n.t(:onto)} #{notify_text}" 
            body =  "#{truncate(custom_text)}"
        end
        return {title: title, body: body}
    end


    def self.notification_type_eql(type, model)
        return 'add_likes_to_'+ model.downcase.pluralize+'_' if  type == 'Like'
        return 'add_shares_to_'+ model.downcase.pluralize+'_' if  type == 'Share'
        return 'add_follows_to_'+ model.downcase.pluralize+'_' if  type == 'Follow'
        return 'add_bookmarks_to_'+ model.downcase.pluralize+'_' if  type == 'Bookmark'
        return 'add_comment_to_'+ model.downcase.pluralize+'_' if  type == 'Comment'
        return 'add_comment_to_followed_'+ model.downcase.pluralize+'_' if  type == 'FollowedComment'
        return 'add_post_to_'+ model.downcase.pluralize+'_' if  type == 'Post'

    end

    def user
        User.find_by_id(self.source_user_id) if self.source_user_id
    end

    def self.user_related(user, page=1)
        self.where("source_user_id != #{user.id} AND target_user_hash ->> '#{user.id}' = 'true'").order('created_at DESC')
    end

    def fix_target_user_hash
        h = {}
        for target_user_id in target_user_ids
            h["#{target_user_id}"] = true
        end
        self.target_user_hash = h
        self.save
    end

    def self.fix_all_target_user_hash
        for notification in Notification.all
            notification.fix_target_user_hash
        end
    end


    def self.trim_blanks(notifications)
        result = []
        for notification in notifications
          result <<  notification if !notification.notifiable.blank?
        end
        return result
    end
end
