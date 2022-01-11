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
require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
