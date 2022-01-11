module Statistic
  class TopTags
    def initialize()
    end

    def top_used
      Tag
        .left_joins(:taggings)
        .group(:id)
        .order("COUNT(taggings.id) DESC")
    end
  end
end
