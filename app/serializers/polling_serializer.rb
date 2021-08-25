class PollingSerializer < ActiveModel::Serializer
  attributes :id, :polls

  def polls
    if scope && scope[:user_id]
      polls = object.poll.pollable.polls
      return ActiveModel::SerializableResource.new(polls, scope: { user_id: scope[:user_id] }, each_serializer: PollSerializer).as_json
    end
  end
end
