module BigBlue
  class TerminateRoom
    def initialize(room:)
      @room = room
      @domain = BigBlue::Connection.domain
      @token = BigBlue::Connection.token
    end

    def call
      response = HTTParty.get(terminate_url)
      body = Hash.from_xml(response.body)
    end

    private

    attr_accessor :room

    def terminate_string
      "endmeetingID=#{room.uuid}&password=#{room.moderator_password}#{@token}"
    end

    def terminate_url
      "#{@domain}end?meetingID=#{room.uuid}&password=#{room.moderator_password}&checksum=#{cheksum(terminate_string)}"
    end

    def cheksum(str)
      Digest::SHA1.hexdigest str
    end
  end
end
