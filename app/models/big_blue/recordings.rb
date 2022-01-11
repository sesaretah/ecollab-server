module BigBlue
  class Recordings
    def initialize(room:)
      @room = room
      @domain = BigBlue::Connection.domain
      @token = BigBlue::Connection.token
    end

    def call
      response = HTTParty.get(attendees_url)
    end

    private

    attr_accessor :room

    def recordings_string
      "getRecordingsmeetingID=#{room.uuid}#{@token}"
    end

    def recordings_url
      "#{@domain}getRecordings?meetingID=#{room.uuid}&checksum=#{cheksum(recoedings_string)}"
    end

    def cheksum(str)
      Digest::SHA1.hexdigest str
    end
  end
end
