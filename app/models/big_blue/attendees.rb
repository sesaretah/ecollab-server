module BigBlue
  class Attendees
    def initialize(room:)
      @room = room
      @domain = BigBlue::Connection.domain
      @token = BigBlue::Connection.token
    end

    def count
      response = HTTParty.get(attendees_url)
      response_evaluator response
    end

    private

    attr_accessor :room

    def response_evaluator(response)
      body = Hash.from_xml(response.body)
      if body["response"]["participantCount"]
        return body["response"]["participantCount"].to_i
      else
        return 0
      end
    end

    def attendees_string
      "getMeetingInfomeetingID=#{room.uuid}#{@token}"
    end

    def attendees_url
      "#{@domain}getMeetingInfo?meetingID=#{room.uuid}&checksum=#{cheksum(attendees_string)}"
    end

    def cheksum(str)
      Digest::SHA1.hexdigest str
    end
  end
end
