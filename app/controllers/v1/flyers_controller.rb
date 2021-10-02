class V1::FlyersController < ApplicationController
  def search
    flyers = Flyer.search params[:q], star: true
    render json: { items: ActiveModel::SerializableResource.new(flyers, each_serializer: FlyerSerializer).as_json }, status: :ok
  end

  def show
    @flyer = Flyer.find(params[:id])
    render json: { data: FlyerSerializer.new(@flyer, scope: { user_id: current_user.id }).as_json, klass: "Flyer" }, status: :ok
  end

  def index
    flyers = Flyer.all
    render json: { data: ActiveModel::SerializableResource.new(flyers, user_id: current_user.id, each_serializer: FlyerSerializer, scope: { user_id: current_user.id }).as_json, klass: "Flyer" }, status: :ok
  end

  def create
    @flyer = Flyer.new(flyer_params)
    @flyer.user_id = current_user.id
    if @flyer.save
      render json: { data: FlyerSerializer.new(@flyer).as_json, klass: "Flyer" }, status: :ok
    end
  end

  def update
    @flyer = Flyer.find(params[:id])
    if @flyer.update_attributes(flyer_params)
      render json: { data: FlyerSerializer.new(@flyer).as_json, klass: "Flyer" }, status: :ok
    end
  end

  def destroy
    @flyer = Flyer.find(params[:id])
    @advertisable = @flyer.advertisable_type.classify.constantize.find_by_id(@flyer.advertisable_id)
    if @flyer.destroy
      render json: { data: "#{@advertisable.class.name}Serializer".classify.safe_constantize.new(@advertisable).as_json, klass: "#{@advertisable.class.name}" }, status: :ok
    else
      render json: { data: @flyer.errors.full_messages }, status: :ok
    end
  end

  def flyer_params
    params.require(:flyer).permit!
  end
end
