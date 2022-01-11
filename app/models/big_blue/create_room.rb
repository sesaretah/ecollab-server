module BigBlue
  class CreateRoom
    attr_accessor :room

    def initialize(room:)
      @room = room
      @domain = BigBlue::Connection.domain
      @token = BigBlue::Connection.token
    end

    def call
      response = HTTParty.get(create_url)
      extarct_passwords(response)
      update_room
    end

    private

    def extarct_passwords(response)
      body = Hash.from_xml(response.body)
      @attendee_password = body["response"]["attendeePW"] if !body["response"]["attendeePW"].blank?
      @moderator_password = body["response"]["moderatorPW"] if !body["response"]["moderatorPW"].blank?
    end

    def update_room
      @room.update_attributes(attendee_password: @attendee_password, moderator_password: @moderator_password)
    end

    def create_url
      "#{@domain}create?meetingID=#{room.uuid}&record=true&checksum=#{cheksum(create_string)}"
    end

    def create_string
      "createmeetingID=#{room.uuid}&record=true#{@token}"
    end

    def cheksum(str)
      Digest::SHA1.hexdigest str
    end
  end
end
