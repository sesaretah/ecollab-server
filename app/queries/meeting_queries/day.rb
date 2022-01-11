module MeetingQueries
  class Day
    def initialize(per_page:, page:, order: "start_time", day:)
      @per_page = per_page
      @page = page
      @order = order
      @day = day
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
      Meeting.where("(start_time <= ? and end_time >= ?) or start_time >= ?", @day, @day, @day).order(@order)
    end
  end
end
