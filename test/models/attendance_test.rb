# == Schema Information
#
# Table name: attendances
#
#  id              :bigint           not null, primary key
#  user_id         :integer
#  attendable_id   :integer
#  attendable_type :string
#  label_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  role_id         :integer
#  duty            :string
#
require 'test_helper'

class AttendanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
