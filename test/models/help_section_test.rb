# == Schema Information
#
# Table name: help_sections
#
#  id            :bigint           not null, primary key
#  section       :string
#  content       :string
#  quill_content :json
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'test_helper'

class HelpSectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
