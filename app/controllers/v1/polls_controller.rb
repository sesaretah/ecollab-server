class V1::PollsController < ApplicationController
  def search
    polls = Poll.search params[:q], star: true
    render json: { items: ActiveModel::SerializableResource.new(polls, each_serializer: PollSerializer).as_json }, status: :ok
  end

  def show
    @poll = Poll.find(params[:id])
    render json: { data: PollSerializer.new(@poll, scope: { user_id: current_user.id }).as_json, klass: "Poll" }, status: :ok
  end

  def overview
    @poll = Poll.find(params[:id])
    render json: { data: PollOverviewSerializer.new(@poll, scope: { user_id: current_user.id }).as_json, klass: "Poll" }, status: :ok
  end

  def index
    polls = Poll.where(pollable_type: params[:pollable_type], pollable_id: params[:pollable_id])
    render json: { data: ActiveModel::SerializableResource.new(polls, user_id: current_user.id, each_serializer: PollSerializer, scope: { user_id: current_user.id }).as_json, klass: "Poll" }, status: :ok
  end

  def create
    @poll = Poll.new(poll_params)
    @poll.user_id = current_user.id
    if @poll.save
      render json: { data: PollSerializer.new(@poll).as_json, klass: "Poll" }, status: :ok
    end
  end

  def update
    @poll = Poll.find(params[:id])
    if @poll.update_attributes(poll_params)
      render json: { data: PollSerializer.new(@poll).as_json, klass: "Poll" }, status: :ok
    end
  end

  def destroy
    @poll = Poll.find(params[:id])
    if @poll.destroy
      render json: { data: "OK", klass: "Poll" }, status: :ok
    else
      render json: { data: @poll.errors.full_messages }, status: :ok
    end
  end

  def poll_params
    params.require(:poll).permit!
  end
end
