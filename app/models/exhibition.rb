class Exhibition < ApplicationRecord
  after_save ThinkingSphinx::RealTime.callback_for(:exhibition)

  has_many :flyers, as: :advertisable, dependent: :destroy
  has_many :uploads, as: :uploadable, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :attendances, as: :attendable, dependent: :destroy
  has_many :questions, as: :questionable, dependent: :destroy
  has_many :tags, through: :taggings

  belongs_to :event, optional: true
  has_one :room, dependent: :destroy

  after_create :add_admin
  after_create :setup_room

  def setup_room
    Room.create(title: self.title, is_private: false, exhibition_id: self.id, moderator_ids: [self.user_id])
  end

  def add_admin
    Attendance.create(attendable_id: self.id, attendable_type: "Exhibition", user_id: self.user_id, duty: "moderator")
  end

  def is_admin(user_id)
    Attendance.where(attendable_id: self.id, attendable_type: "Exhibition", user_id: user_id, duty: "moderator").any?
  end

  def self.attending(user_id)
    e1 = Meeting.joins(:attendances).where("attendable_type = ? and attendances.user_id = ?", "Meeting", User.first.id).pluck(:event_id).uniq
    e2 = Event.joins(:attendances).where("attendable_type = ? and attendances.user_id = ?", "Event", User.first.id).pluck(:id).uniq
    self.where("event_id in (?)", (e1 + e2).uniq)
  end

  def self.user_recent_exhibitions(user_id)
    self
      .joins(:attendances)
      .where("attendable_type = ? and attendances.user_id = ?", "Exhibition", user_id).order("attendances.created_at desc").limit(10)
  end

  def self.attending_ids(user_id)
    self.attending(user_id).pluck(:id)
  end

  def self.search_w_params(params, user, per_page)
    with_hash = {}
    with_hash["activated"] = true if user.blank? || user.ability.blank? || !user.ability.administration
    with_hash["tag_ids"] = Tag.title_to_id(params[:tags].split(",")) if params[:tags] && params[:tags].length > 0
    with_hash["event_id"] = params[:event_id].to_i if params[:event_id] && params[:event_id].length > 0 && params[:event_id] != "0" && params[:event_id] != "null"
    if params[:event_id] && params[:event_id].length > 0 && params[:event_id] != "0" && params[:event_id] != "null"
      exhibition_ids = self.attending_ids(user.id)
      with_hash["id_number"] = exhibition_ids
    end
    exhibitions = self.search params[:q], star: true, with: with_hash, :order => :id, :page => params[:page], :per_page => per_page
    counter = self.search_count params[:q], star: true, with: with_hash
    pages = (counter / per_page.to_f).ceil
    return { exhibitions: exhibitions, pages: pages }
  end

  def cover
    upload = Upload.where("uploadable_type = ? and uploadable_id = ? and upload_type = ?", "Exhibition", self.id, "cover").last
    return upload.cropped_url if !upload.blank?
  end
end
