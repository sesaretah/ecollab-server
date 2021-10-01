class Event < ApplicationRecord
  after_save ThinkingSphinx::RealTime.callback_for(:event)

  has_many :attendances, as: :attendable, dependent: :destroy
  has_many :discussions, as: :discussable, dependent: :destroy
  has_many :flyers, as: :advertisable, dependent: :destroy
  has_many :uploads, as: :uploadable, dependent: :destroy

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :meetings, dependent: :destroy
  has_many :exhibitions, dependent: :destroy
  after_create :add_admin

  def add_admin
    Attendance.create(attendable_id: self.id, attendable_type: "Event", user_id: self.user_id, duty: "moderator")
  end

  def is_admin(user_id)
    Attendance.where(attendable_id: self.id, attendable_type: "Event", user_id: user_id, duty: "moderator").any?
  end

  def meeting_tags
    Tag
      .left_joins(:taggings)
      .where("taggable_id in (?) and taggable_type = ?", self.meetings.pluck(:id), "Meeting")
      .group(:id)
      .order("COUNT(taggings.id) DESC")
  end

  def self.owner(user_id)
    self
      .left_joins(:attendances)
      .where("attendable_type = ? and attendances.user_id = ? and duty = ?", "Event", user_id, "moderator")
  end

  def is_attending(user_id)
    Attendance.where("attendable_id = ? and attendable_type = ? and user_id = ?", self.id, "Event", user_id).any?
  end

  def self.related(user_id)
    self
      .left_joins(:attendances)
      .where("attendable_type = ? and attendances.user_id = ?", "Event", user_id)
  end

  def self.user_recent_events(user_id)
    self
      .joins(:attendances)
      .where("attendable_type = ? and attendances.user_id = ?", "Event", user_id).order("attendances.created_at").limit(10)
  end

  def self.date_range(s, e, user_id)
    from = Time.at(s.to_i / 1000).to_datetime.beginning_of_day
    to = Time.at(e.to_i / 1000).to_datetime.beginning_of_day
    all_ids = self.where("(start_date between ? and ?) OR (end_date between ? and ?) OR (start_date <= ? and end_date >= ?)", from, to, from, to, from, to).pluck(:id)
    private_ids = self.where("id in (?) and is_private is true", all_ids).pluck(:id)
    event_ids = Attendance.where("attendable_id in (?) and attendable_type = ? and user_id = ?", private_ids, "Event", user_id).pluck(:attendable_id)
    return all_ids - private_ids + event_ids
  end

  def self.search_w_params(params, user, per_page)
    with_hash = {}
    event_ids = self.date_range(params[:start_from], params[:start_to], user.id)
    with_hash["tag_ids"] = Tag.title_to_id(params[:tags].split(",")) if params[:tags] && params[:tags].length > 0
    with_hash["id_number"] = event_ids
    events = self.search params[:q], star: true, with: with_hash, :page => params[:page], :per_page => per_page, :order => "start_date ASC"
    counter = self.search_count params[:q], star: true, with: with_hash
    pages = (counter / per_page.to_f).ceil
    return { events: events, pages: pages }
  end

  def cover
    upload = Upload.where("uploadable_type = ? and uploadable_id = ? and upload_type = ?", "Event", self.id, "cover").last
    return upload.cropped_url if !upload.blank?
  end
end
