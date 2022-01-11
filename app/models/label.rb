# == Schema Information
#
# Table name: labels
#
#  id         :bigint           not null, primary key
#  title      :string
#  color      :string
#  icon_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Label < ApplicationRecord
  has_many :attendances
  belongs_to :icon
end
