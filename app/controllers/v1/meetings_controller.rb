class V1::MeetingsController < ApplicationController
  # before_action :fix_date, only: [:create, :update]

  def search
    with_hash = {}
    with_hash["tag_ids"] = Tag.title_to_id(params[:tags].split(",")) if params[:tags] && params[:tags].length > 0
    with_hash["event_id"] = params[:event_id].to_i if params[:event_id] && params[:event_id].length > 0 && params[:event_id] != 0
    with_hash["start_time"] = Time.at(params[:start_from].to_i / 1000).to_datetime..Time.at(params[:start_to].to_i / 1000).to_datetime if params[:start_from]
    meetings = Meeting.search params[:q], star: true, with: with_hash, :page => params[:page], :per_page => 6
    all_matches = Meeting.search params[:q], star: true, with: with_hash
    pages = all_matches.length / 2
    render json: { data: ActiveModel::SerializableResource.new(meetings, scope: { page: params[:page].to_i, pages: pages, user_id: current_user.id }, each_serializer: MeetingIndexSerializer).as_json, klass: "Meeting" }, status: :ok
  end

  def show
    @meeting = Meeting.find(params[:id])
    render json: { data: MeetingSerializer.new(@meeting, scope: { user_id: current_user.id }).as_json, klass: "Meeting" }, status: :ok
  end

  def join_bigblue
    @meeting = Meeting.find(params[:id])
    room = @meeting.room
    room.create_bigblue if !room.is_bigblue_running #&& @meeting.is_presenter(current_user.id)
    url = room.join_bigblue(@meeting.user_duty(current_user.id), URI::escape(current_user.profile.name))
    render json: { data: { url: url }, klass: "MeetingUrl" }, status: :ok
  end

  def index
    meetings = Meeting.where("start_time > ?", DateTime.current.beginning_of_day).paginate(page: params[:page], per_page: 2)
    render json: { data: ActiveModel::SerializableResource.new(meetings, scope: { page: params[:page].to_i, user_id: current_user.id }, each_serializer: MeetingIndexSerializer).as_json, klass: "Meeting" }, status: :ok
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
    if @meeting.destroy
      render json: { data: @meeting, klass: "Meeting" }, status: :ok
    else
      render json: { data: @meeting.errors.full_messages }, status: :ok
    end
  end

  def meeting_params
    params.require(:meeting).permit!
  end
end
