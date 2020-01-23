module Haravan
  module Settlement
    class BrandsController < ApplicationController
      http_basic_authenticate_with(
          name: Rails.application.credentials.dig(:haravan, :http_basic, :name),
          password: Rails.application.credentials.dig(:haravan, :http_basic, :passwd)
      )
      before_action :set_from_time_to_time
      layout 'haravan/settlement'

      def index
        @service = Haravan::SettlementService.new((@from_day..@to_day))
        @brands = @service.call
        # @settlement = @service.call
        # @brands = @settlement.brands

        respond_to do |format|
          format.html {}
          format.json { render json: @brands }
        end
      end

      def show
      end

      private

      def set_from_time_to_time
        @from_day = to_datetime(params[:from], Time.now.in_time_zone('UTC').beginning_of_day)
        @to_day = to_datetime(params[:to], @from_day + 1.day)
        Rails.logger.debug @from_day
        Rails.logger.debug @to_day
      end

      def to_datetime(string, default)
        string.in_time_zone('UTC').to_date rescue default.in_time_zone('UTC').to_date
      end
    end
  end
end
