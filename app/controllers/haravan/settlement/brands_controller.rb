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
        set_terms(@from_day..@to_day)

        @service = Haravan::SettlementService.new(@terms)
        @brands = @service.call

        @orders_count = Haravan::Order.count_by(
            created_at_min: @terms.start_at,
            created_at_max: @terms.end_at
        )

        @delivered_orders_count = Haravan::Order.count_by(
            fulfillment_status: 'shipped',
            created_at_min: @terms.start_at,
            created_at_max: @terms.end_at
        )

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

      def set_terms(time_range = nil)
        time_range = time_range || (Time.now.in_time_zone('UTC').yesterday.beginning_of_day..Time.now.in_time_zone('UTC').yesterday.end_of_day)
        @terms = Haravan::Vo::Terms.new(time_range.first, time_range.last)
      end
    end
  end
end
