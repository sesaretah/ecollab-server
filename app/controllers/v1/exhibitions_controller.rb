class V1::ExhibitionsController < ApplicationController
  # before_action :fix_date, only: [:create, :update]

  def search
    with_hash = {}
    with_hash["tag_ids"] = Tag.title_to_id(params[:tags].split(",")) if params[:tags] && params[:tags].length > 0
    event = Event.where(shortname: params[:event_name]).first if params[:event_name] != ""
    with_hash["event_id"] = event.id if !event.blank?
    with_hash["event_id"] = params[:event_id].to_i if params[:event_id] && params[:event_id].length > 0 && params[:event_id] != "0"
    exhibition_ids = Exhibition.attending_ids(current_user.id)
    with_hash["id_number"] = exhibition_ids
    exhibitions = Exhibition.search params[:q], star: true, with: with_hash, :order => :id, :page => params[:page], :per_page => 12
    counter = Exhibition.search_count params[:q], star: true, with: with_hash
    pages = (counter / 12.to_f).ceil

    render json: { data: ActiveModel::SerializableResource.new(exhibitions, scope: { page: params[:page].to_i, pages: pages }, each_serializer: ExhibitionSerializer).as_json, klass: "Exhibition" }, status: :ok
  end

  def show
    @exhibition = Exhibition.find(params[:id])
    render json: { data: ExhibitionSerializer.new(@exhibition, scope: { user_id: current_user.id }).as_json, klass: "Exhibition" }, status: :ok
  end

  def related
    exhibitions = Exhibition.attending(current_user.id).paginate(page: params[:page], per_page: 12)
    pages = (Exhibition.attending(current_user.id).count / 12.to_f).ceil
    render json: { data: ActiveModel::SerializableResource.new(exhibitions, user_id: current_user.id, each_serializer: ExhibitionSerializer, scope: { user_id: current_user.id, page: params[:page].to_i, pages: pages }).as_json, klass: "Exhibition" }, status: :ok
  end

  def index
    exhibitions = Exhibition.paginate(page: params[:page], per_page: 6)
    render json: { data: ActiveModel::SerializableResource.new(exhibitions, user_id: current_user.id, each_serializer: ExhibitionSerializer, scope: { user_id: current_user.id, page: params[:page].to_i }).as_json, klass: "Exhibition" }, status: :ok
  end

  def create
    @exhibition = Exhibition.new(exhibition_params)
    @exhibition.user_id = current_user.id
    if @exhibition.save
      Tagging.extract_tags(params[:tags], "Exhibition", @exhibition.id)
      render json: { data: ExhibitionSerializer.new(@exhibition, scope: { user_id: current_user.id }).as_json, klass: "Exhibition" }, status: :ok
    end
  end

  def update
    @exhibition = Exhibition.find(params[:id])
    if @exhibition.update_attributes(exhibition_params)
      Tagging.extract_tags(params[:tags], "Exhibition", @exhibition.id)
      render json: { data: ExhibitionSerializer.new(@exhibition, scope: { user_id: current_user.id }).as_json, klass: "Exhibition" }, status: :ok
    end
  end

  def destroy
    @exhibition = Exhibition.find(params[:id])
    if @exhibition.is_admin(current_user.id) && @exhibition.destroy
      render json: { data: @exhibition, klass: "Exhibition" }, status: :ok
    else
      render json: { data: @exhibition.errors.full_messages }, status: :ok
    end
  end

  def exhibition_params
    params.require(:exhibition).permit!
  end
end
