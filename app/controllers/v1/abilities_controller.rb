class V1::AbilitiesController < ApplicationController
  def show
    ability = Ability.where(user_id: params[:id]).first
    if ability.blank?
      ability = Ability.create(user_id: params[:id], create_event: false, create_exhibition: false, modify_ability: false, administration: false)
    end
    render json: { data: AbilitySerializer.new(ability).as_json, klass: "Ability" }, status: :ok
  end

  def update
    ability = Ability.find(params[:id])
    if ability.update_attributes(ability_params)
      render json: { data: AbilitySerializer.new(ability).as_json, klass: "Ability" }, status: :ok
    end
  end

  def destroy
    @ability = Ability.find(params[:id])
    if @ability.destroy
      render json: { data: @ability, klass: "Ability" }, status: :ok
    else
      render json: { data: @ability.errors.full_messages }, status: :ok
    end
  end

  def ability_params
    params.require(:ability).permit!
  end
end
