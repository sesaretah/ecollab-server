# == Schema Information
#
# Table name: abilities
#
#  id                :bigint           not null, primary key
#  user_id           :integer
#  create_event      :boolean
#  create_exhibition :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  modify_ability    :boolean
#  administration    :boolean
#
class AbilitySerializer < ActiveModel::Serializer
  attributes :id, :create_event, :create_exhibition, :modify_ability, :administration, :profile

  def profile
    profile = object.user.profile
    return profile
  end
end
