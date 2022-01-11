# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  name       :string
#  surename   :string
#  mobile     :string
#  bio        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  faculty    :string
#  privacy    :json
#  country    :string
#  twitter    :string
#  linkdin    :string
#  email      :string
#  instagram  :string
#  telegram   :string
#  phone      :string
#
require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
