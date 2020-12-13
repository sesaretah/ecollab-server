class V1::ParticipationsController < ApplicationController

  def show
    @participation = Participation.find(params[:id])
    render json: { data:  ParticipationSerializer.new(@participation, scope: {user_id: current_user.id}, user_id: current_user.id).as_json, klass: 'Participation'}, status: :ok
  end


  def create
    participation = Participation.where(user_id: current_user.id, room_id: params[:room_id]).first
    if participation.blank?
      participation = Participation.new(participation_params)
      participation.user_id = current_user.id
    end
    participation.add_activity(params[:activity])
    if participation.save
      render json: { data: ParticipationSerializer.new(participation).as_json, klass: 'Participation' }, status: :ok
    end
  end


  def participation_params
    params.require(:participation).permit!
  end
end
