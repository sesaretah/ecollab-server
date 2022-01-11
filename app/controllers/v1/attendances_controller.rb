class V1::AttendancesController < ApplicationController
  def search
    attendances = Attendance.search params[:q], star: true
    render json: { items: ActiveModel::SerializableResource.new(attendances, each_serializer: AttendanceSerializer).as_json }, status: :ok
  end

  def attend
    attendable = Handler::AttendanceHandler::AttendHandler.new(params: params, user: current_user).call
    render json: { data: "#{attendable.class.name}Serializer".classify.constantize.new(attendable, scope: { user_id: current_user.id }).as_json, klass: "#{attendable.class.name}" }, status: :ok
  end

  def change_duty
    attendance = Handler::AttendanceHandler::ChangeDutyHandler.new(params: params, user: current_user).call
    render json: { data: AttendanceSerializer.new(attendance, scope: { user_id: current_user.id }).as_json, klass: "Attendance" }, status: :ok
  end

  def show
    @attendance = Attendance.find(params[:id])
    render json: { data: AttendanceSerializer.new(@attendance, scope: { user_id: current_user.id }).as_json, klass: "Attendance" }, status: :ok
  end

  def index
    result = Preparer::AttendanceIndex.new(params: params).call
    render json: { data: { users: ActiveModel::SerializableResource.new(result[:profiles], each_serializer: ProfileIndexSerializer).as_json, attendances: ActiveModel::SerializableResource.new(result[:attendances], user_id: current_user.id, each_serializer: AttendanceSerializer, scope: { user_id: current_user.id }).as_json }, klass: "Attendance" }, status: :ok
  end

  def create
    @attendance = Attendance.new(attendance_params)
    @attendance.user_id = params[:user_id]
    @attendance.duty = "listener"
    if @attendance.save
      render json: { data: AttendanceSerializer.new(@attendance).as_json, klass: "Attendance" }, status: :ok
    end
  end

  def destroy
    @attendance = Attendance.find(params[:id])
    if @attendance.attendable_owner && @attendance.destroy
      render json: { data: "OK" }, status: :ok
    else
      render json: { data: @attendance.errors.full_messages }, status: :ok
    end
  end

  def attendance_params
    params.require(:attendance).permit!
  end
end
