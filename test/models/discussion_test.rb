# == Schema Information
#
# Table name: discussions
#
#  id               :bigint           not null, primary key
#  discussable_id   :integer
#  discussable_type :string
#  title            :string
#  discussion_type  :string
#  is_private       :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'test_helper'

class DiscussionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
