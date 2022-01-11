# == Schema Information
#
# Table name: exhibitions
#
#  id         :bigint           not null, primary key
#  title      :string
#  info       :string
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  is_active  :boolean
#
require 'test_helper'

class ExhibitionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
