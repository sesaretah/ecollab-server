module FullTextSearcher
  class Searcher
    def initialize(params:, user:, per_page:, searchable:, timescale: "time", with: %w(tag_ids event_id id_number))
      @start_from = params[:start_from]
      @start_to = params[:start_to]
      @tags = params[:tags]
      @page = params[:page]
      @query = params[:q]
      @event_id = params[:event_id]
      @per_page = per_page
      @user = user
      @searchable = searchable
      @timescale = timescale
      @with = with
      if params[:registration_status].blank?
        @registration_status = "all"
      else
        @registration_status = params[:registration_status]
      end
    end

    def call
      if !@with.include?("idnumber") || !id_number.blank?
        FullTextSearcher::Formater.new(results: spnx_search, pages: pages, searchable: @searchable).format
      else
        FullTextSearcher::Formater.new(searchable: @searchable).format
      end
    end

    private

    attr_accessor :params, :query, :searchable, :registration_status, :timescale

    def spnx_search
      searchable.search query, star: true, with: with_hasher, :page => @page, :per_page => @per_page, :order => order
    end

    def order
      "start_#{timescale} ASC" if @with.include?("idnumber")
      ""
    end

    def with_hasher
      @with.reduce({}) do |memo, item|
        !self.send(item).blank? ? memo.merge!({ "#{item}" => send(item) }) : memo
      end
    end

    def pages
      (count / @per_page.to_f).ceil
    end

    def count
      searchable.search_count query, star: true, with: with_hasher
    end

    def id_number
      q = DateRangeQuery.new(from: @start_from, to: @start_to, user_id: @user.id, klass: @searchable, timescale: timescale)
      q.send(registration_status).map(&:id)
    end

    def tag_ids
      Convertor::TagConvertor.new(items: @tags.split(",")).titles_to_ids if @tags && @tags.length > 0
    end

    def event_id
      @event_id.to_i if @event_id && @event_id.length > 0 && @event_id != "0" && @event_id != "null"
    end

    def activated
      true if @user.blank? || @user.ability.blank? || !@user.ability.administration
      false
    end
  end
end
