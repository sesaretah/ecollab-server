# == Schema Information
#
# Table name: polls
#
#  id             :bigint           not null, primary key
#  pollable_id    :integer
#  pollable_type  :string
#  content        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  answer_type    :string
#  answer_content :json
#  user_id        :integer
#
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
