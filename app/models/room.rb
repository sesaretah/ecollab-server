class Room < ApplicationRecord
  require "digest/sha1"
  before_create :set_uuid
  #before_save :set_title
  after_create :setup_janus
  before_destroy :destroy_janus

  # has_many :users, through: :participations
  # has_many :participations
  belongs_to :meeting, optional: true
  belongs_to :exhibition, optional: true

  Domain = "http://webinar3.ut.ac.ir/bigbluebutton/api/"
  Se = "f4c70b0793683eaf0cc8e4bc49147420f734cbc546c63b26ff5cc0412764ec49"

  def set_uuid
    self.uuid = SecureRandom.random_number(10000000)
    self.pin = SecureRandom.hex(10)
    self.secret = SecureRandom.hex(10)

    self.vuuid = SecureRandom.random_number(10000000)
    self.vpin = SecureRandom.hex(10)
    self.vsecret = SecureRandom.hex(10)
  end

  def set_title
    self.title = self.meeting.title
  end

  def setup_janus
    RoomCreateJob.perform_later(self.id)
    VideoroomCreateJob.perform_later(self.id)
  end

  def destroy_janus
    RoomDestroyJob.perform_later(self.uuid, self.secret)
  end

  def ref_class
    if !self.meeting_id.blank?
      return self.meeting
    else
      return self.exhibition
    end
  end

  def create_bigblue
    cheksum_string = "createmeetingID=" + self.uuid + "&record=true" + Se
    cheksum = Digest::SHA1.hexdigest cheksum_string
    url = Domain + "create?meetingID=" + self.uuid + "&record=true" + "&checksum=" + cheksum
    response = HTTParty.get(url)
    body = Hash.from_xml(response.body)
    self.attendee_password = body["response"]["attendeePW"] if !body["response"]["attendeePW"].blank?
    self.moderator_password = body["response"]["moderatorPW"] if !body["response"]["moderatorPW"].blank?
    self.save
  end

  def is_bigblue_running
    cheksum_string = "isMeetingRunningmeetingID=" + self.uuid + Se
    cheksum = Digest::SHA1.hexdigest cheksum_string
    url = Domain + "isMeetingRunning?meetingID=" + self.uuid + "&checksum=" + cheksum
    response = HTTParty.get(url)
    body = Hash.from_xml(response.body)
    return true if body["response"]["running"] == "true"
    return false if body["response"]["running"] == "false"
  end

  def end_bigblue
    cheksum_string = "endmeetingID=" + self.uuid + "&password=" + self.moderator_password + Se
    cheksum = Digest::SHA1.hexdigest cheksum_string
    url = Domain + "end?meetingID=" + self.uuid + "&password=" + self.moderator_password + "&checksum=" + cheksum
    response = HTTParty.get(url)
    body = Hash.from_xml(response.body)
  end

  def join_bigblue(duty, name)
    duty == "listener" ? password = self.attendee_password : password = self.moderator_password
    cheksum_string = "joinmeetingID=" + self.uuid + "&password=" + password + "&fullName=" + name + Se
    cheksum = Digest::SHA1.hexdigest cheksum_string
    url = Domain + "join?meetingID=" + self.uuid + "&password=" + password + "&fullName=" + name + "&checksum=" + cheksum
    return url
  end

  def meeting_attendees_count
    cheksum_string = "getMeetingInfomeetingID=" + self.uuid + Se
    cheksum = Digest::SHA1.hexdigest cheksum_string
    url = Domain + "getMeetingInfo?meetingID=" + self.uuid + "&checksum=" + cheksum
    response = HTTParty.get(url)
    body = Hash.from_xml(response.body)
    if body["response"]["participantCount"]
      return body["response"]["participantCount"].to_i
    else
      return 0
    end
  end
end
