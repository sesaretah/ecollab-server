module BigBlue
  class JoinRoom
    def initialize(room:, duty: "listener", name:)
      @room = room
      @duty = duty
      @name = name
      @domain = BigBlue::Connection.domain
      @token = BigBlue::Connection.token
    end

    def call
      join_url
    end

    private

    attr_accessor :room, :duty, :name

    def join_string
      "joinmeetingID=#{room.uuid}&password=#{duty_password}&fullName=#{name}#{@token}"
    end

    def join_url
      "#{@domain}join?meetingID=#{room.uuid}&password=#{duty_password}&fullName=#{name}&checksum=#{cheksum(join_string)}"
    end

    def duty_password
      @duty == "listener" ? room.attendee_password : room.moderator_password
    end

    def cheksum(str)
      Digest::SHA1.hexdigest str
    end
  end
end
