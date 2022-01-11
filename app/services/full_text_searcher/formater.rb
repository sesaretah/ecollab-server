module FullTextSearcher
  class Formater
    def initialize(results: [], pages: 0, searchable:)
      @results = results
      @pages = pages
      @searchable = searchable
    end

    def format
      { searchable_plural => @results, "pages" => @pages }
    end

    def searchable_plural
      @searchable.name.underscore.pluralize.to_sym
    end
  end
end
