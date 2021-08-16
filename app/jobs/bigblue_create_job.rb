class BigblueCreateJob < ApplicationJob
  require "digest/sha1"
  queue_as :default
  URL = "http://webinar3.ut.ac.ir/bigbluebutton/api/"
  SE = "f4c70b0793683eaf0cc8e4bc49147420f734cbc546c63b26ff5cc0412764ec49"

  def perform(room_id)
    room = Room.find_by_id(room_id)
    cheksum_string = "createmeetingID=" + room.uuid + SE
    cheksum = Digest::SHA1.hexdigest cheksum_string
    url = URL + "create?meetingID=" + room.uuid + "&checksum=" + cheksum
    response = HTTParty.get(url)
    body = Hash.from_xml(response.body)
    p body
    p body["response"]["attendeePW"]
    room.attendee_password = body["response"]["attendeePW"]
    room.moderator_password = body["response"]["moderatorPW"]
    room.save
  end
end
