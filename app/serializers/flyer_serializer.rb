class FlyerSerializer < ActiveModel::Serializer
  attributes :id, :title, :content,
             :quill_content, :is_default,
             :advertisable_link

  def advertisable_link
    "#{object.advertisable_type.underscore.pluralize}/#{object.advertisable_id}"
  end
end
