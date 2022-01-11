# == Schema Information
#
# Table name: polls
#
#  id             :bigint           not null, primary key
#  pollable_id    :integer
#  pollable_type  :string
#  content        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  answer_type    :string
#  answer_content :json
#  user_id        :integer
#
require 'test_helper'

class PollTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
