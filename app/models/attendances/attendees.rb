module Attendances
  class Attendees
    def initialize(attendable:)
      @attendable = attendable
    end

    def profiles
      Profile.where("user_id in (?)", user_ids).order("name asc")
    end

    private

    attr_reader :attendable

    def user_ids
      attendable.attendances.pluck(:user_id)
    end
  end
end
