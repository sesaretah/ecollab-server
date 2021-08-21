class AbilitySerializer < ActiveModel::Serializer
  attributes :id, :create_event, :create_exhibition, :modify_ability, :administration, :profile

  def profile
    profile = object.user.profile
    return profile
  end
end
