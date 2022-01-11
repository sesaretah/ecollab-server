module Convertor
  class TagConvertor
    attr_accessor :items

    def initialize(items:)
      @items = items
    end

    def titles_to_ids
      convert :title, :id
    end

    def ids_to_titles
      convert :id, :title
    end

    private

    def convert(from, to)
      reduced = reducer(from, to)
      reduced.compact.map(&to)
    end

    def reducer(from, to)
      items.reduce([]) { |memo, item| memo << Tag.send("find_by_#{from.to_s}", item) }
    end
  end
end
