# == Schema Information
#
# Table name: flyers
#
#  id                :bigint           not null, primary key
#  title             :string
#  content           :text
#  user_id           :integer
#  advertisable_id   :integer
#  advertisable_type :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  quill_content     :json
#  is_default        :boolean
#
class FlyerSerializer < ActiveModel::Serializer
  attributes :id, :title, :content,
             :quill_content, :is_default,
             :advertisable_link

  def advertisable_link
    "#{object.advertisable_type.underscore.pluralize}/#{object.advertisable_id}"
  end
end
