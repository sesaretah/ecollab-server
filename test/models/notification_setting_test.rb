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
require 'test_helper'

class NotificationSettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
