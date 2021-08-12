class V1::AttendancesController < ApplicationController
  def search
    attendances = Attendance.search params[:q], star: true
    render json: { items: ActiveModel::SerializableResource.new(attendances, each_serializer: AttendanceSerializer).as_json }, status: :ok
  end

  def change_duty
    @attendance = Attendance.find(params[:id])
    @attendance.duty = params[:duty]
    @attendance.save
    render json: { data: AttendanceSerializer.new(@attendance, scope: { user_id: current_user.id }).as_json, klass: "Attendance" }, status: :ok
  end

  def show
    @attendance = Attendance.find(params[:id])
    render json: { data: AttendanceSerializer.new(@attendance, scope: { user_id: current_user.id }).as_json, klass: "Attendance" }, status: :ok
  end

  def index
    prepare_list(params[:attendable_id], params[:attendable_type], params[:q])
  end

  def create
    @attendance = Attendance.new(attendance_params)
    @attendance.user_id = params[:user_id]
    @attendance.duty = "presenter"
    if @attendance.save
      render json: { data: AttendanceSerializer.new(@attendance).as_json, klass: "Attendance" }, status: :ok
    end
  end

  def destroy
    @attendance = Attendance.find(params[:id])
    if @attendance.destroy
      render json: { data: "OK" }, status: :ok
    else
      render json: { data: @attendance.errors.full_messages }, status: :ok
    end
  end

  def attendance_params
    params.require(:attendance).permit!
  end

  def prepare_list(attendable_id, attendable_type, q)
    attendances = Attendance.where(attendable_id: attendable_id, attendable_type: attendable_type)
    if q.blank? || q.length < 3
      profiles = Profile.all
    else
      profiles = Profile.search q, star: true
    end
    render json: { data: { users: ActiveModel::SerializableResource.new(profiles, each_serializer: ProfileSerializer).as_json, attendances: ActiveModel::SerializableResource.new(attendances, user_id: current_user.id, each_serializer: AttendanceSerializer, scope: { user_id: current_user.id }).as_json }, klass: "Attendance" }, status: :ok
  end
end
