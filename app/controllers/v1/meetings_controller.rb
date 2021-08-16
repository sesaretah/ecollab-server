class V1::MeetingsController < ApplicationController
  # before_action :fix_date, only: [:create, :update]

  def search
    meetings = Meeting.search params[:q], star: true
    render json: { items: ActiveModel::SerializableResource.new(meetings, each_serializer: MeetingSerializer).as_json }, status: :ok
  end

  def show
    @meeting = Meeting.find(params[:id])
    render json: { data: MeetingSerializer.new(@meeting, scope: { user_id: current_user.id }).as_json, klass: "Meeting" }, status: :ok
  end

  def join_bigblue
    @meeting = Meeting.find(params[:id])
    room = @meeting.room
    p room
    p @meeting.is_presenter(current_user.id)
    p !room.is_bigblue_running
    room.create_bigblue if !room.is_bigblue_running #&& @meeting.is_presenter(current_user.id)
    p room.is_bigblue_running
    p @meeting.user_duty(current_user.id)
    p current_user.profile.name
    url = room.join_bigblue(@meeting.user_duty(current_user.id), URI::escape(current_user.profile.name))
    render json: { data: { url: url }, klass: "MeetingUrl" }, status: :ok
  end

  def index
    meetings = Meeting.all
    render json: { data: ActiveModel::SerializableResource.new(meetings, user_id: current_user.id, each_serializer: MeetingSerializer, scope: { user_id: current_user.id }).as_json, klass: "Meeting" }, status: :ok
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
