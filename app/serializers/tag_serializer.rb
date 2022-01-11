# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TagSerializer < ActiveModel::Serializer
  attributes :id, :title

  def label
    object.title
  end
end
