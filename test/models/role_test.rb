# == Schema Information
#
# Table name: roles
#
#  id           :bigint           not null, primary key
#  title        :string
#  ability      :json
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  default_role :boolean
#
require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
