module MeetingQueries
  class Event
    def initialize(per_page:, page:, order: "start_time", event_id:)
      @per_page = per_page
      @page = page
      @order = order
      @event_id = event_id
    end

    def call
      { meetings: meetings, pages: count }
    end

    def meetings
      query.paginate(page: @page, per_page: @per_page)
    end

    def count
      (query.count / 12.to_f).ceil
    end

    def query
      Meeting.where(event_id: @event_id).order(@order)
    end
  end
end
