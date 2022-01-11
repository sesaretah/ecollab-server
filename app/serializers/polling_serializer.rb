# == Schema Information
#
# Table name: pollings
#
#  id         :bigint           not null, primary key
#  poll_id    :integer
#  user_id    :integer
#  outcome    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  outcomes   :json
#
class PollingSerializer < ActiveModel::Serializer
  attributes :id, :polls

  def polls
    if scope && scope[:user_id]
      polls = object.poll.pollable.polls
      return ActiveModel::SerializableResource.new(polls, scope: { user_id: scope[:user_id] }, each_serializer: PollSerializer).as_json
    end
  end
end
