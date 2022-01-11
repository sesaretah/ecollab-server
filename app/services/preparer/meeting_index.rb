module Preparer
  class MeetingIndex
    def initialize(params:, per_page: 12)
      @params = params
      @per_page = per_page
      @today = DateTime.current.beginning_of_day
    end

    def call
      if params[:event_id].blank?
        today_meetings
      else
        event_meetings
      end
    end

    private

    def today_meetings
      MeetingQueries::Day.new(per_page: @per_page, page: @params[:page], day: DateTime.current.beginning_of_day).call
    end

    def event_meetings
      MeetingQueries::Day.new(per_page: @per_page, page: @params[:page], event_id: @params[:event_id]).call
    end
  end
end
