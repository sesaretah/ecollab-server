# == Schema Information
#
# Table name: rooms
#
#  id                 :bigint           not null, primary key
#  title              :string
#  is_private         :boolean
#  uuid               :string
#  secret             :string
#  pin                :string
#  activated          :boolean
#  moderator_ids      :json
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  meeting_id         :integer
#  vuuid              :string
#  vpin               :string
#  vsecret            :string
#  exhibition_id      :integer
#  attendee_password  :string
#  moderator_password :string
#
require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
