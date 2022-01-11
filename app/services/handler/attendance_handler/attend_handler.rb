module Handler
  module AttendanceHandler
    class AttendHandler
      def initialize(params:, user:)
        @params = params
        @user = user
      end

      def call
        if flag
          create_attendance
        else
          destory_attendance
        end
      end

      private

      attr_accessor :params, :user

      def create_attendance
        Attendance.create(attendable_id: params[:attendable_id], attendable_type: params[:attendable_type], user_id: user.id, duty: "listener") if attendance.blank?
        find_attendable
      end

      def destory_attendance
        attendable = find_attendable
        attendance.destroy if attendance.attendable_owner
        attendable
      end

      def attendance
        Attendance.where("attendable_id = ? and attendable_type = ? and user_id = ?", params[:attendable_id], params[:attendable_type], user.id).first
      end

      def find_attendable
        attendance.attendable if !attendance.blank?
      end

      def flag
        ActiveModel::Type::Boolean.new.cast(params[:flag])
      end
    end
  end
end
