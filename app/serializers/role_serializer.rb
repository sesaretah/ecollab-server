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
class RoleSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :ability, :default_role
  has_many :users,  serializer: UserSerializer
  def default_role
    object.default_role ? true : false
  end
end
