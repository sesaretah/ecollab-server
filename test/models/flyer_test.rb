# == Schema Information
#
# Table name: flyers
#
#  id                :bigint           not null, primary key
#  title             :string
#  content           :text
#  user_id           :integer
#  advertisable_id   :integer
#  advertisable_type :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  quill_content     :json
#  is_default        :boolean
#
require 'test_helper'

class FlyerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
