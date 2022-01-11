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
class Ability < ApplicationRecord
  belongs_to :user
end
