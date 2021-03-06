class V1::EventsController < ApplicationController
  def search
    results = FullTextSearcher::Searcher.new(params: params, user: current_user, per_page: 12, timescale: "date", searchable: Event).call
    #results = Event.search_w_params(params, current_user, 6)
    render json: { data: ActiveModel::SerializableResource.new(results[:events], scope: { page: params[:page].to_i, pages: results[:pages], user_id: current_user.id }, each_serializer: EventIndexSerializer).as_json, klass: "Event" }, status: :ok
  end

  def search_shortname
    events = Event.where(shortname: params[:shortname])
    render json: { data: ActiveModel::SerializableResource.new(events, each_serializer: EventIndexSerializer).as_json, klass: "Event" }, status: :ok
  end

  def shortname_list
    events = Event.where(shortname: params[:shortname])
    render json: { data: ActiveModel::SerializableResource.new(events, each_serializer: EventIndexSerializer).as_json, klass: "Event" }, status: :ok
  end

  def tags
    @event = Event.find(params[:id])
    tags = @event.meeting_tags
    render json: { data: ActiveModel::SerializableResource.new(tags, each_serializer: TagSerializer).as_json, klass: "Tag" }, status: :ok
  end

  def meetings
    @event = Event.find(params[:id])
    meetings = @event.meetings.includes(:taggings).where("start_time >= ? and end_time <= ? and taggings.tag_id in (?)", Time.at(params[:start_time].to_i / 1000), Time.at(params[:end_time].to_i / 1000), params[:tag_ids].split(","))
    render json: { data: ActiveModel::SerializableResource.new(meetings, user_id: current_user.id, each_serializer: MeetingIndexSerializer, scope: { user_id: current_user.id }).as_json, klass: "Meeting" }, status: :ok
  end

  def show
    @event = Event.find(params[:id])
    render json: { data: EventSerializer.new(@event, scope: { user_id: current_user.id }).as_json, klass: "Event" }, status: :ok
  end

  def related
    events = Event.related(current_user.id)
    render json: { data: ActiveModel::SerializableResource.new(events, user_id: current_user.id, each_serializer: EventIndexSerializer, scope: { user_id: current_user.id, page: params[:page].to_i }).as_json, klass: "Event" }, status: :ok
  end

  def owner
    if params[:event_name].blank?
      events = Event.owner(current_user.id)
    else
      events = Event.where(shortname: params[:event_name])
    end

    render json: { data: ActiveModel::SerializableResource.new(events, user_id: current_user.id, each_serializer: EventIndexSerializer, scope: { user_id: current_user.id, page: params[:page].to_i }).as_json, klass: "Event" }, status: :ok
  end

  def index
    today = DateTime.current.beginning_of_day
    events = Event.where("(start_date <= ? and end_date >= ?) or start_date >= ?", today, today, today).paginate(page: params[:page], per_page: 6)
    pages = (Event.where("(start_date <= ? and end_date >= ?) or start_date >= ?", today, today, today).count / 6.to_f).ceil
    render json: { data: ActiveModel::SerializableResource.new(events, user_id: current_user.id, each_serializer: EventIndexSerializer, scope: { user_id: current_user.id, page: params[:page].to_i, pages: pages }).as_json, klass: "Event" }, status: :ok
  end

  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id
    if @event.save
      Extractor::TaggingExtractor.new(titles: params[:tags], taggable: @event).call
      render json: { data: EventSerializer.new(@event, scope: { user_id: current_user.id }).as_json, klass: "Event" }, status: :ok
    end
  end

  def update
    @event = Event.find(params[:id])

    if @event.update_attributes(event_params)
      Extractor::TaggingExtractor.new(titles: params[:tags], taggable: @event).call
      render json: { data: EventSerializer.new(@event, scope: { user_id: current_user.id }).as_json, klass: "Event" }, status: :ok
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.is_admin(current_user.id) && @event.destroy
      render json: { data: @event, klass: "Event" }, status: :ok
    else
      render json: { data: @event.errors.full_messages }, status: :ok
    end
  end

  def event_params
    params.require(:event).permit!
  end
end
