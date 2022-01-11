module Handler
  module AttendanceHandler
    class ChangeDutyHandler
      def initialize(params:, user:)
        @params = params
      end

      def call
        attendance = find_attendance
        if attendance.attendable_owner
          attendance.duty = params[:duty]
          attendance.save
        end
        attendance
      end

      private

      attr_accessor :params

      def find_attendance
        if !params[:id].blank?
          Attendance.find(params[:id])
        else
          Attendance.where(user_id: user.id, attendable_type: "Meeting", attendable_id: meeting.id).first if !params[:uuid].blank? && !user.blank? && !meeting.blank?
        end
      end

      def room
        Room.find_by_id(params[:room_id]) if !params[:uuid].blank?
      end

      def meeting
        room.meeting if !params[:uuid].blank? && !room.blank?
      end

      def user
        User.where(uuid: params[:uuid]).first if !params[:uuid].blank?
      end
    end
  end
end
