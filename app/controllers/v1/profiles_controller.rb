class V1::ProfilesController < ApplicationController
  def index
    profiles = Profile.all
    render json: { data: ActiveModel::SerializableResource.new(profiles, each_serializer: ProfileSerializer).as_json, klass: "Profile" }, status: :ok
  end

  def search
    profiles = Profile.search params[:q], star: true, :page => params[:page], :per_page => 12
    counter = Profile.search_count params[:q], star: true
    pages = (counter / 12.to_f).ceil
    render json: { data: ActiveModel::SerializableResource.new(profiles, scope: { page: params[:page].to_i, pages: pages, user_id: current_user.id }, each_serializer: ProfileSerializer).as_json, klass: "Profile" }, status: :ok
  end

  def show
    @profile = Profile.find(params[:id])
    render json: { data: ProfileDetailSerializer.new(@profile, scope: { user_id: current_user.id }).as_json, klass: "Profile" }, status: :ok
  end

  def mine
    profiles = Profile.where(user_id: current_user.id)
    render json: { data: ActiveModel::SerializableResource.new(profiles, each_serializer: ProfileSerializer).as_json, klass: "MyProfile" }, status: :ok
  end

  def my
    @profile = current_user.profile
    if @profile
      render json: { data: ProfileDetailSerializer.new(@profile, scope: { user_id: current_user.id }).as_json, klass: "MyProfile" }, status: :ok
    else
      render json: { data: "No profile", klass: "MyProfile" }, status: :ok
    end
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id
    if @profile.save
      render json: { data: ProfileSerializer.new(@profile).as_json, klass: "Profile" }, status: :ok
    end
  end

  def update
    @profile = current_user.profile

    if @profile.update_attributes(profile_params)
      Extractor::TaggingExtractor.new(titles: params[:tags], taggable: current_user).call
      render json: { data: ProfileSerializer.new(@profile).as_json, klass: "Profile" }, status: :ok
    end
  end

  def profile_params
    params.require(:profile).permit!
  end
end
