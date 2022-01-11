module Attendances
  class UserList
    def initialize(klass:, user:)
      @klass = klass
      @user = user
    end

    def all
      klass
        .joins(:attendances)
        .where("attendable_type = ? and attendances.user_id = ?", klass.name, user.id)
    end

    def recent(count)
      all.order("attendances.created_at desc").limit(count)
    end

    def attending?(attendable_id)
      Attendance.where("attendable_id = ? and attendable_type = ? and user_id = ?", attendable_id, "Meeting", user.id).any?
    end

    private

    attr_reader :klass, :user
  end
end
