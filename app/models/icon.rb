# == Schema Information
#
# Table name: icons
#
#  id         :bigint           not null, primary key
#  content    :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Icon < ApplicationRecord
  has_many :labels
end
