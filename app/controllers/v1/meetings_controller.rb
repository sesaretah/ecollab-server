class V1::MeetingsController < ApplicationController
  # before_action :fix_date, only: [:create, :update]

  def search
    results = Meeting.search_w_params(params, current_user, 12)
    render json: { data: ActiveModel::SerializableResource.new(results[:meetings], scope: { page: params[:page].to_i, pages: results[:pages], user_id: current_user.id }, each_serializer: MeetingIndexSerializer).as_json, klass: "Meeting" }, status: :ok
  end

  def my
    meetings = Meeting.user_meetings(current_user.id)
    render json: { data: ActiveModel::SerializableResource.new(meetings, scope: { user_id: current_user.id }, each_serializer: MeetingIndexSerializer).as_json, klass: "Meeting" }, status: :ok
  end

  def show
    @meeting = Meeting.find(params[:id])
    render json: { data: MeetingSerializer.new(@meeting, scope: { user_id: current_user.id }).as_json, klass: "Meeting" }, status: :ok
  end

  def join_bigblue
    @meeting = Meeting.find(params[:id])
    room = @meeting.room
    room.create_bigblue if !room.is_bigblue_running #&& @meeting.is_presenter(current_user.id)
    room.meeting_attendees_count >= @meeting.capacity ? full = true : full = false
    DateTime.now >= @meeting.start_time && DateTime.now <= @meeting.end_time ? timely = true : timely = false
    url = room.join_bigblue(@meeting.user_duty(current_user.id), URI::escape(current_user.profile.name))
    render json: { data: { url: url, full: full, timely: timely }, klass: "MeetingUrl" }, status: :ok
  end

  def index
    today = DateTime.current.beginning_of_day
    if params[:event_id].blank?
      meetings = Meeting.where("(start_time <= ? and end_time >= ?) or start_time >= ?", today, today, today).order("start_time").paginate(page: params[:page], per_page: 12)
      pages = (Meeting.where("(start_time <= ? and end_time >= ?) or start_time >= ?", today, today, today).count / 12.to_f).ceil
    else
      meetings = Meeting.where(event_id: params[:event_id]).order("start_time").paginate(page: params[:page], per_page: 12)
      pages = (Meeting.where(event_id: params[:event_id]).count / 12.to_f).ceil
    end
    render json: { data: ActiveModel::SerializableResource.new(meetings, scope: { page: params[:page].to_i, pages: pages, user_id: current_user.id }, each_serializer: MeetingIndexSerializer).as_json, klass: "Meeting" }, status: :ok
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.user_id = current_user.id
    if @meeting.save
      Tagging.extract_tags(params[:tags], "Meeting", @meeting.id)
      render json: { data: MeetingSerializer.new(@meeting).as_json, klass: "Meeting" }, status: :ok
    end
  end

  def update
    @meeting = Meeting.find(params[:id])
    if @meeting.update_attributes(meeting_params)
      Tagging.extract_tags(params[:tags], "Meeting", @meeting.id)
      render json: { data: MeetingSerializer.new(@meeting).as_json, klass: "Meeting" }, status: :ok
    end
  end

  def destroy
    @meeting = Meeting.find(params[:id])
    if @meeting.is_admin(current_user.id) && @meeting.destroy
      render json: { data: @meeting, klass: "Meeting" }, status: :ok
    else
      render json: { data: @meeting.errors.full_messages }, status: :ok
    end
  end

  def meeting_params
    params.require(:meeting).permit!
  end
end
