# == Schema Information
#
# Table name: questions
#
#  id                :bigint           not null, primary key
#  content           :string
#  questionable_type :string
#  questionable_id   :integer
#  user_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  is_private        :boolean
#
require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
