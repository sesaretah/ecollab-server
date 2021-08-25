class PollSerializer < ActiveModel::Serializer
  attributes :id, :content, :answer_type, :answer_content, :outcome, :outcomes

  def outcome
    if scope && scope[:user_id]
      polling = object.pollings.where(user_id: scope[:user_id]).first
      return polling.outcome if !polling.blank?
    end
  end

  def outcomes
    if scope && scope[:user_id]
      polling = object.pollings.where(user_id: scope[:user_id]).first
      return polling.outcomes if !polling.blank?
    end
  end

  def pollable_link
    "#{object.pollable_type.underscore.pluralize}/#{object.pollable_id}"
  end
end
