class V1::PollingsController < ApplicationController
  def create
    @polling = Polling.where(user_id: current_user.id, poll_id: params[:poll_id]).first
    if @polling.blank?
      @polling = Polling.new(polling_params)
    end
    @polling.outcome = params[:outcome].to_i
    @polling.user_id = current_user.id
    if @polling.save
      render json: { data: PollingSerializer.new(@polling, scope: { user_id: current_user.id }).as_json, klass: "Polling" }, status: :ok
    end
  end

  def destroy
    @polling = Polling.find(params[:id])
    if @polling.destroy
      render json: { data: @polling, klass: "Polling" }, status: :ok
    else
      render json: { data: @polling.errors.full_messages }, status: :ok
    end
  end

  def polling_params
    params.require(:polling).permit!
  end
end
