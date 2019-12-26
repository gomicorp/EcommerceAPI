module DateTimeParamRangeParsable
  private

  def range_params
    if params[:from].present? && params[:to].present?
      from = to_datetime(params[:from], Time.zone.now.beginning_of_day)
      to = to_datetime(params[:to], Time.zone.now.end_of_day)

      (from..to)
    end
  end

  def to_datetime(string, default)
    string.to_date.in_time_zone rescue nil || default
  end
end
