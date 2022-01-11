# == Schema Information
#
# Table name: uploads
#
#  id              :bigint           not null, primary key
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  uuid            :string
#  converted       :boolean
#  user_id         :integer
#  uploadable_type :string
#  uploadable_id   :integer
#  upload_type     :string
#  is_private      :boolean
#  crop_settings   :json
#
require 'test_helper'

class UploadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
