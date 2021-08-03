class V1::TagsController < ApplicationController
  def search
    tags = Tag.search params[:q], star: true
    render json: { items: ActiveModel::SerializableResource.new(tags, each_serializer: TagSerializer).as_json }, status: :ok
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.user_id = current_user.id
    if @tag.save
      render json: { data: TagSerializer.new(@tag).as_json }, status: :ok
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    if @tag.destroy
      render json: { data: @tag, klass: "Tag" }, status: :ok
    else
      render json: { data: @tag.errors.full_messages }, status: :ok
    end
  end

  def tag_params
    params.require(:tag).permit!
  end
end
