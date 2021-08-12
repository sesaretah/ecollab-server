class V1::ExhibitionsController < ApplicationController
  # before_action :fix_date, only: [:create, :update]

  def search
    exhibitions = Exhibition.search params[:q], star: true
    render json: { items: ActiveModel::SerializableResource.new(exhibitions, each_serializer: ExhibitionSerializer).as_json }, status: :ok
  end

  def show
    @exhibition = Exhibition.find(params[:id])
    render json: { data: ExhibitionSerializer.new(@exhibition, scope: { user_id: current_user.id }).as_json, klass: "Exhibition" }, status: :ok
  end

  def index
    exhibitions = Exhibition.all
    render json: { data: ActiveModel::SerializableResource.new(exhibitions, user_id: current_user.id, each_serializer: ExhibitionSerializer, scope: { user_id: current_user.id }).as_json, klass: "Exhibition" }, status: :ok
  end

  def create
    @exhibition = Exhibition.new(exhibition_params)
    @exhibition.user_id = current_user.id
    if @exhibition.save
      Tagging.extract_tags(params[:tags], "Exhibition", @exhibition.id)
      render json: { data: ExhibitionSerializer.new(@exhibition).as_json, klass: "Exhibition" }, status: :ok
    end
  end

  def update
    @exhibition = Exhibition.find(params[:id])
    if @exhibition.update_attributes(exhibition_params)
      Tagging.extract_tags(params[:tags], "Exhibition", @exhibition.id)
      render json: { data: ExhibitionSerializer.new(@exhibition).as_json, klass: "Exhibition" }, status: :ok
    end
  end

  def destroy
    @exhibition = Exhibition.find(params[:id])
    if @exhibition.destroy
      render json: { data: @exhibition, klass: "Exhibition" }, status: :ok
    else
      render json: { data: @exhibition.errors.full_messages }, status: :ok
    end
  end

  def exhibition_params
    params.require(:exhibition).permit!
  end
end
