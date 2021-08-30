class V1::AttendancesController < ApplicationController
  def search
    attendances = Attendance.search params[:q], star: true
    render json: { items: ActiveModel::SerializableResource.new(attendances, each_serializer: AttendanceSerializer).as_json }, status: :ok
  end

  def attend
    attendance = Attendance.where("attendable_id = ?and attendable_type = ? and user_id = ?", params[:attendable_id], params[:attendable_type], current_user.id).first
    attendable = attendance.attendable if !attendance.blank?
    flag = ActiveModel::Type::Boolean.new.cast(params[:flag])
    if flag
      attendance = Attendance.create(attendable_id: params[:attendable_id], attendable_type: params[:attendable_type], user_id: current_user.id, duty: "listener") if attendance.blank?
      attendable = attendance.attendable
    else
      attendance.destroy if attendance.attendable_owner
    end
    render json: { data: "#{attendable.class.name}Serializer".classify.constantize.new(attendable, scope: { user_id: current_user.id }).as_json, klass: "#{attendable.class.name}" }, status: :ok
  end

  def change_duty
    @attendance = Attendance.find(params[:id]) if !params[:id].blank?
    if !params[:uuid].blank?
      user = User.where(uuid: params[:uuid]).first
      room = Room.find_by_id(params[:room_id])
      meeting = room.meeting if !room.blank?
      @attendance = Attendance.where(user_id: user.id, attendable_type: "Meeting", attendable_id: meeting.id).first if !user.blank? && !meeting.blank?
    end
    if @attendance.attendable_owner
      @attendance.duty = params[:duty]
      @attendance.save
    end
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

  def prepare_list(attendable_id, attendable_type, q)
    attendances = Attendance.where(attendable_id: attendable_id, attendable_type: attendable_type)
    if q.blank? || q.length < 3
      profiles = Profile.last(20)
    else
      profiles = Profile.search q, star: true
    end
    render json: { data: { users: ActiveModel::SerializableResource.new(profiles, each_serializer: ProfileSerializer).as_json, attendances: ActiveModel::SerializableResource.new(attendances, user_id: current_user.id, each_serializer: AttendanceSerializer, scope: { user_id: current_user.id }).as_json }, klass: "Attendance" }, status: :ok
  end
end
