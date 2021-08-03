class TagSerializer < ActiveModel::Serializer
  attributes :id, :title

  def label
    object.title
  end
end
