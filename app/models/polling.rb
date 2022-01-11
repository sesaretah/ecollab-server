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
class Polling < ApplicationRecord
  belongs_to :poll
  belongs_to :user

  before_save :handle_mutiple_select

  def handle_mutiple_select
    poll = self.poll
    if poll.answer_type == "multiple_select"
      self.outcomes = [] if self.outcomes.blank?
      if self.outcomes.include? self.outcome
        self.outcomes = self.outcomes - [self.outcome]
      else
        self.outcomes = self.outcomes + [self.outcome]
      end
    end
  end
end
