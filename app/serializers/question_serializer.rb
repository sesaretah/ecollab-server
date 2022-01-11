# == Schema Information
#
# Table name: questions
#
#  id                :bigint           not null, primary key
#  content           :string
#  questionable_type :string
#  questionable_id   :integer
#  user_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  is_private        :boolean
#
class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :content, :is_private, :questionable_link

  def questionable_link
    "#{object.questionable_type.underscore.pluralize}/#{object.questionable_id}"
  end
end
