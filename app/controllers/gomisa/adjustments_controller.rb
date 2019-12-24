module Gomisa
  class AdjustmentsController < BaseController
    include DateTimeParamRangeParsable

    # GET /gomisa/adjustments.json
    def index
      @service = AdjustmentIndexService.new(reason_params, range_params)
      @service.call

      @adjustments = @service.adjustments
    end

    protected

    def reason_params
      params[:reason].presence || 'All'
    end
  end
end
