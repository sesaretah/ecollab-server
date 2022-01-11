# == Schema Information
#
# Table name: devices
#
#  id         :bigint           not null, primary key
#  user_id    :integer
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class DeviceSerializer < ActiveModel::Serializer
  attributes :token
  belongs_to :user
end
