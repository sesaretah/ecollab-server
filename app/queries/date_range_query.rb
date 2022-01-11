class DateRangeQuery
  def initialize(from:, to:, user_id:, klass:, timescale: "time")
    @from = Time.at(from.to_i / 1000).to_datetime
    @to = Time.at(to.to_i / 1000).to_datetime
    @user_id = user_id
    @klass = klass
    @timescale = timescale
  end

  def publics
    @klass.where("is_private is false").where(inside_range)
  end

  def all
    (publics + registered).uniq
  end

  def registered
    @klass
      .joins(:attendances)
      .where("attendable_type = ? and attendances.user_id = ?", @klass.name, user_id)
      .where(inside_range)
  end

  def not_registered
    publics.where("id not in (?)", registered.pluck(:attendable_id))
  end

  private

  attr_reader :from, :to, :user_id, :timescale

  def range_finder
  end

  def inside_range
    "(#{start_scale} between '#{from}' and '#{to}') OR (#{end_scale} between '#{from}' and '#{to}') OR (#{start_scale} <= '#{from}' and #{end_scale} >= '#{to}')"
  end

  def start_scale
    "start_#{timescale}"
  end

  def end_scale
    "end_#{timescale}"
  end
end
