class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :profile_id
  has_one :profile, serializer: ProfileSerializer

  def profile_id
    object.profile.id if !object.profile.blank?
  end
end
