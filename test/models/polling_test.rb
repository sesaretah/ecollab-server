# == Schema Information
#
# Table name: pollings
#
#  id         :bigint           not null, primary key
#  poll_id    :integer
#  user_id    :integer
#  outcome    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  outcomes   :json
#
require 'test_helper'

class PollingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
