module Preparer
  class AttendanceIndex
    def initialize(params:)
      @params = params
      @query = params[:query]
      @attendable_id = params[:attendable_id]
      @attendable_type = params[:attendable_type]
    end

    def call
      return { attendances: find_attendances, profiles: profiles }
    end

    private

    def find_attendances
      Attendance.where(attendable_id: @attendable_id, attendable_type: @attendable_type)
    end

    def profiles
      if @query.blank? || @query.length < 3
        profiles = Profile.last(20)
      else
        profiles = Profile.search @query, star: true
      end
      profiles
    end
  end
end
