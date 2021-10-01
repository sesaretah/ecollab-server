class V1::ExhibitionsController < ApplicationController
  def search
    results = Exhibition.search_w_params(params, current_user, 12)
    render json: { data: ActiveModel::SerializableResource.new(results[:exhibitions], scope: { page: params[:page].to_i, pages: results[:pages] }, each_serializer: ExhibitionIndexSerializer).as_json, klass: "Exhibition" }, status: :ok
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
    render json: { data: ActiveModel::SerializableResource.new(exhibitions, user_id: current_user.id, each_serializer: ExhibitionIndexSerializer, scope: { user_id: current_user.id, page: params[:page].to_i }).as_json, klass: "Exhibition" }, status: :ok
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
