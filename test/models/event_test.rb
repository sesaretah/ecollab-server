# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  title         :string
#  event_type    :string
#  info          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#  is_private    :boolean
#  crop_settings :json
#  start_date    :date
#  end_date      :date
#  shortname     :string
#
require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
