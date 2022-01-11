module BigBlue
  class Status
    def initialize(room:)
      @room = room
      @domain = BigBlue::Connection.domain
      @token = BigBlue::Connection.token
    end

    def call
      response = HTTParty.get(status_url)
      running?(response)
    end

    private

    attr_accessor :room

    def running?(response)
      body = Hash.from_xml(response.body)
      return true if body["response"]["running"] == "true"
      return false if body["response"]["running"] == "false"
    end

    def status_string
      "isMeetingRunningmeetingID=#{room.uuid}#{@token}"
    end

    def status_url
      "#{@domain}isMeetingRunning?meetingID=#{room.uuid}&checksum=#{cheksum(status_string)}"
    end

    def cheksum(str)
      Digest::SHA1.hexdigest str
    end
  end
end
