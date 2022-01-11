# == Schema Information
#
# Table name: meetings
#
#  id                      :bigint           not null, primary key
#  title                   :string
#  info                    :text
#  event_id                :integer
#  meeting_type            :string
#  start_time              :datetime
#  end_time                :datetime
#  location                :string
#  is_private              :boolean
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  capacity                :integer
#  external_link           :string
#  user_id                 :integer
#  internal                :boolean
#  bigblue                 :boolean
#  sata                    :boolean
#  sata_displays           :json
#  per_display             :integer
#  number_of_sata_displays :integer
#
require 'test_helper'

class MeetingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
