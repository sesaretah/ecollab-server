# == Schema Information
#
# Table name: discussions
#
#  id               :bigint           not null, primary key
#  discussable_id   :integer
#  discussable_type :string
#  title            :string
#  discussion_type  :string
#  is_private       :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Discussion < ApplicationRecord
  belongs_to :discussable, polymorphic: true
end
