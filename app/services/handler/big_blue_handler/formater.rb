module Handler
  module BigBlueHandler
    class Formater
      def initialize(timely: false, url: "", full: true)
        @timely = timely
        @url = url
        @full = full
      end

      def format
        { timely: @timely, url: @url, full: @full }
      end
    end
  end
end
