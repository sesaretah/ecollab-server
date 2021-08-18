class V1::EventsController < ApplicationController
  def search
    with_hash = {}
    with_hash["tag_ids"] = Tag.title_to_id(params[:tags].split(",")) if params[:tags] && params[:tags].length > 0
    with_hash["start_date"] = Time.at(params[:start_from].to_i / 1000).to_datetime..Time.at(params[:start_to].to_i / 1000).to_datetime if params[:start_from]
    events = Event.search params[:q], star: true, with: with_hash, :page => params[:page], :per_page => 6
    all_matches = Event.search params[:q], star: true, with: with_hash
    pages = all_matches.length / 2
    render json: { data: ActiveModel::SerializableResource.new(events, scope: { page: params[:page].to_i, pages: pages, user_id: current_user.id }, each_serializer: EventIndexSerializer).as_json, klass: "Event" }, status: :ok
  end

  def tags
    @event = Event.find(params[:id])
    tags = @event.meeting_tags
    render json: { data: ActiveModel::SerializableResource.new(tags, each_serializer: TagSerializer).as_json, klass: "Tag" }, status: :ok
  end

  def meetings
    @event = Event.find(params[:id])
    meetings = @event.meetings.joins(:taggings).where("start_time >= ? and end_time <= ? and taggings.tag_id in (?)", Time.at(params[:start_time].to_i / 1000), Time.at(params[:end_time].to_i / 1000), params[:tag_ids].split(","))
    render json: { data: ActiveModel::SerializableResource.new(meetings, user_id: current_user.id, each_serializer: MeetingIndexSerializer, scope: { user_id: current_user.id }).as_json, klass: "Meeting" }, status: :ok
  end

  def show
    @event = Event.find(params[:id])
    render json: { data: EventSerializer.new(@event, scope: { user_id: current_user.id }).as_json, klass: "Event" }, status: :ok
  end

  def related
    events = Event.where("start_date > ?", DateTime.current.beginning_of_day)
    render json: { data: ActiveModel::SerializableResource.new(events, user_id: current_user.id, each_serializer: EventIndexSerializer, scope: { user_id: current_user.id, page: params[:page].to_i }).as_json, klass: "Event" }, status: :ok
  end

  def owner
    events = Event.owner(current_user.id)
    render json: { data: ActiveModel::SerializableResource.new(events, user_id: current_user.id, each_serializer: EventIndexSerializer, scope: { user_id: current_user.id, page: params[:page].to_i }).as_json, klass: "Event" }, status: :ok
  end

  def index
    events = Event.where("start_date > ?", DateTime.current.beginning_of_day).paginate(page: params[:page], per_page: 6)
    render json: { data: ActiveModel::SerializableResource.new(events, user_id: current_user.id, each_serializer: EventIndexSerializer, scope: { user_id: current_user.id, page: params[:page].to_i }).as_json, klass: "Event" }, status: :ok
  end

  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id
    if @event.save
      Tagging.extract_tags(params[:tags], "Event", @event.id)
      render json: { data: EventSerializer.new(@event).as_json, klass: "Event" }, status: :ok
    end
  end

  def update
    @event = Event.find(params[:id])
    Tagging.extract_tags(params[:tags], "Event", @event.id)
    if @event.update_attributes(event_params)
      render json: { data: EventSerializer.new(@event).as_json, klass: "Event" }, status: :ok
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      render json: { data: @event, klass: "Event" }, status: :ok
    else
      render json: { data: @event.errors.full_messages }, status: :ok
    end
  end

  def event_params
    params.require(:event).permit!
  end
end
