# == Schema Information
#
# Table name: labels
#
#  id         :bigint           not null, primary key
#  title      :string
#  color      :string
#  icon_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class LabelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
