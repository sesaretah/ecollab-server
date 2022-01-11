module Preparer
  module RoomPreparer
    class ProfileDisplayPreparer
      def initilize(params:, room:)
        @params = params
        @room = room
        @display = params["display"].to_i
      end

      def call
        profiles
      end

      private

      attr_accessor :display, :room

      def profiles
        meeting = room.meeting
        pp = meeting.per_display
        if display <= meeting.number_of_sata_displays
          Attendances::attendees.profiles[((display - 1) * pp)..((display * pp) - 1)]
        else
          []
        end
      end
    end
  end
end
