class V1::EventsController < ApplicationController
  def search
    events = Event.search params[:q], star: true
    render json: { items: ActiveModel::SerializableResource.new(events, each_serializer: EventSerializer).as_json }, status: :ok
  end

  def show
    @event = Event.find(params[:id])
    render json: { data: EventSerializer.new(@event, scope: { user_id: current_user.id }).as_json, klass: "Event" }, status: :ok
  end

  def index
    events = Event.all
    render json: { data: ActiveModel::SerializableResource.new(events, user_id: current_user.id, each_serializer: EventSerializer, scope: { user_id: current_user.id }).as_json, klass: "Event" }, status: :ok
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
