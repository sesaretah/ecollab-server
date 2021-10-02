class Meeting < ApplicationRecord
  after_save ThinkingSphinx::RealTime.callback_for(:meeting)
  after_create :setup_room

  has_many :attendances, as: :attendable, dependent: :destroy
  has_many :discussions, as: :discussable, dependent: :destroy
  has_many :flyers, as: :advertisable, dependent: :destroy
  has_many :uploads, as: :uploadable, dependent: :destroy
  has_many :polls, as: :pollable, dependent: :destroy

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :polls, as: :pollable, dependent: :destroy

  has_one :room, dependent: :destroy

  belongs_to :event

  after_create :add_admin

  def setup_room
    #Room.create(title: self.title, is_private: self.is_private, meeting_id: self.id, moderator_ids: [self.user_id])
  end

  def add_admin
    Attendance.create(attendable_id: self.id, attendable_type: "Meeting", user_id: self.user_id, duty: "moderator")
  end

  def is_admin(user_id)
    Attendance.where(attendable_id: self.id, attendable_type: "Meeting", user_id: user_id, duty: "moderator").any?
  end

  def is_presenter(user_id)
    Attendance.where("attendable_id = ? and attendable_type = ? and user_id = ? and duty in (?)", self.id, "Meeting", user_id, ["moderator", "presenter"]).any?
  end

  def user_duty(user_id)
    attendance = Attendance.where("attendable_id = ? and attendable_type = ? and user_id = ?", self.id, "Meeting", user_id).last
    if !attendance.blank?
      return attendance.duty
    else
      return "listener"
    end
  end

  def is_attending(user_id)
    Attendance.where("attendable_id = ? and attendable_type = ? and user_id = ?", self.id, "Meeting", user_id).any?
  end

  def self.user_meetings(user_id)
    self
      .joins(:attendances)
      .where("attendable_type = ? and attendances.user_id = ?", "Meeting", user_id)
  end

  def self.user_recent_meetings(user_id)
    self
      .joins(:attendances)
      .where("attendable_type = ? and attendances.user_id = ?", "Meeting", user_id).order("attendances.created_at desc").limit(10)
  end

  def attendees
    user_ids = self.attendances.order("id asc").pluck(:user_id)
    profiles = Profile.where("user_id in (?)", user_ids).order("name asc")
    return profiles
  end

  def self.date_range(s, e, status = "all", user_id = nil)
    status = "all" if status.blank?
    from = Time.at(s.to_i / 1000).to_datetime
    to = Time.at(e.to_i / 1000).to_datetime
    if status == "all"
      publics = self.where("(is_private is false) and ((start_time between ? and ?) OR (end_time between ? and ?) OR (start_time <= ? and end_time >= ?))", from, to, from, to, from, to).pluck(:id)
      registered = self
        .joins(:attendances)
        .where("(attendable_type = ? and attendances.user_id = ?) and ((start_time between ? and ?) OR (end_time between ? and ?) OR (start_time <= ? and end_time >= ?))", "Meeting", user_id, from, to, from, to, from, to).pluck(:id)
      meetings = (publics + registered).uniq
    end
    if status == "registered"
      meetings = self
        .joins(:attendances)
        .where("(attendable_type = ? and attendances.user_id = ?) and ((start_time between ? and ?) OR (end_time between ? and ?) OR (start_time <= ? and end_time >= ?))", "Meeting", user_id, from, to, from, to, from, to).pluck(:id)
    end
    if status == "not_registered"
      publics = self.where("(is_private is false) and ((start_time between ? and ?) OR (end_time between ? and ?) OR (start_time <= ? and end_time >= ?))", from, to, from, to, from, to).pluck(:id)
      registered = self
        .joins(:attendances)
        .where("(attendable_type = ? and attendances.user_id = ?) and ((start_time between ? and ?) OR (end_time between ? and ?) OR (start_time <= ? and end_time >= ?))", "Meeting", user_id, from, to, from, to, from, to).pluck(:id)
      meetings = publics - registered
    end
    return meetings
  end

  def self.search_w_params(params, user, per_page)
    with_hash = {}
    with_hash["tag_ids"] = Tag.title_to_id(params[:tags].split(",")) if params[:tags] && params[:tags].length > 0
    with_hash["event_id"] = params[:event_id].to_i if params[:event_id] && params[:event_id].length > 0 && params[:event_id] != "0" && params[:event_id] != "null"
    meeting_ids = self.date_range(params[:start_from], params[:start_to], params[:registration_status], user.id)
    with_hash["id_number"] = meeting_ids
    meetings = self.search params[:q], star: true, with: with_hash, :page => params[:page], :per_page => per_page, :order => "start_time ASC"
    counter = self.search_count params[:q], star: true, with: with_hash
    pages = (counter / per_page.to_f).ceil
    return { meetings: meetings, pages: pages }
  end

  def cover
    upload = Upload.where("uploadable_type = ? and uploadable_id = ? and upload_type = ?", "Meeting", self.id, "cover").last
    return upload.cropped_url if !upload.blank?
  end
end
