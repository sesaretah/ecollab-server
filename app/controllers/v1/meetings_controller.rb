class V1::MeetingsController < ApplicationController
  def search
    results = FullTextSearcher::Searcher.new(params: params, user: current_user, per_page: 12, searchable: Meeting).call
    render json: { data: ActiveModel::SerializableResource.new(results[:meetings], scope: { page: params[:page].to_i, pages: results[:pages], user_id: current_user.id }, each_serializer: MeetingIndexSerializer).as_json, klass: "Meeting" }, status: :ok
  end

  def my
    meetings = Attendances::UserList.new(klass: Meeting, user: current_user).all
    render json: { data: ActiveModel::SerializableResource.new(meetings, scope: { user_id: current_user.id }, each_serializer: MeetingIndexSerializer).as_json, klass: "Meeting" }, status: :ok
  end

  def show
    @meeting = Meeting.find(params[:id])
    render json: { data: MeetingSerializer.new(@meeting, scope: { user_id: current_user.id }).as_json, klass: "Meeting" }, status: :ok
  end

  def join_bigblue
    @meeting = Meeting.find(params[:id])
    result = Handler::BigBlueHandler::Joiner.new(meeting: @meeting, user: current_user).call
    render json: { data: result, klass: "MeetingUrl" }, status: :ok
  end

  def index
    result = Preparer::MeetingIndex.new(params: params)
    render json: { data: ActiveModel::SerializableResource.new(result[:meetings], scope: { page: params[:page].to_i, pages: result[:pages], user_id: current_user.id }, each_serializer: MeetingIndexSerializer).as_json, klass: "Meeting" }, status: :ok
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.user_id = current_user.id
    if @meeting.save
      Extractor::TaggingExtractor.new(titles: params[:tags], taggable: @meeting).call
      render json: { data: MeetingSerializer.new(@meeting).as_json, klass: "Meeting" }, status: :ok
    end
  end

  def update
    @meeting = Meeting.find(params[:id])
    if @meeting.update_attributes(meeting_params)
      Extractor::TaggingExtractor.new(titles: params[:tags], taggable: @meeting).call
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
