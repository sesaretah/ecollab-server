class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :content, :is_private, :questionable_link

  def questionable_link
    "#{object.questionable_type.underscore.pluralize}/#{object.questionable_id}"
  end
end
