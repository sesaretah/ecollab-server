module Handler
  module BigBlueHandler
    class Joiner
      attr_accessor :meeting

      def initialize(meeting:, user:, formater: Handler::BigBlueHandler::Formater, joiner: BigBlue::JoinRoom, creator: BigBlue::CreateRoom, counter: BigBlue::Attendees, status: BigBlue::Status)
        @meeting = meeting
        @user = user
        @duty = meeting.user_duty(user.id)
        @formater = formater
        @joiner = joiner
        @creator = creator
        @counter = counter
        @status = status
      end

      def call
        create_room
        @formater.new(timely: timely?, full: full?, url: join_url).format
      end

      private

      def join_url
        @joiner.new(room: room, duty: @duty, name: name).call
      end

      def name
        URI::escape(@user.profile.name) if !@user.blank? && !@user.profile.blank?
      end

      def room
        meeting.room
      end

      def full?
        @counter.new(room: room).count >= meeting.capacity ? true : false
      end

      def create_room
        @creator.new(room: room).call if !room_exist?
      end

      def room_exist?
        @status.new(room: room).call
      end

      def timely?
        DateTime.now >= meeting.start_time && DateTime.now <= meeting.end_time ? true : false
      end
    end
  end
end
