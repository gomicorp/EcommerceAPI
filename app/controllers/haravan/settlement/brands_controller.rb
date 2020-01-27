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
        search

        respond_to do |format|
          format.html {}
          format.json { render json: @brands }
        end
      end

      def show
        search

        respond_to do |format|
          format.html {}
          format.json { render json: @brands }
        end
      end

      private

      def search
        set_terms(@from_day..@to_day)

        @orders_count = Haravan::Order.count_by(
            created_at_min: @terms.start_at,
            created_at_max: @terms.end_at
        )

        @service = Haravan::SettlementService.new(@terms, params)
        @brands = @service.call
        @delivered_orders_count = @service.orders.count

        unless params.dig(:id).present?
          message_args = {
              '기간내 전체 주문' => "<b>#{helpers.unit_format(@orders_count, unit: '건')}</b>",
              '기간내 해당 주문' => "<b>#{helpers.unit_format(@service.orders.count, unit: '건')}</b>"
          }

          @subject = message_args.map { |label, value| "<span class='px-2 d-block d-sm-inline-block'>#{label}: #{value}</span>" }.join('<span class="d-none d-sm-inline-block"> | </span>')
        end

        @search_method = params.dig(:search, :method).to_s
        @method_labels = {
            'fulfillment_status' => '배송 완료',
            'financial_status' => '결제 완료',
            '' => '배송 완료'
        }
      end

      def set_from_time_to_time
        @from_day = to_datetime(params[:from], Time.now.in_time_zone('UTC').beginning_of_day)
        @to_day = to_datetime(params[:to], @from_day + 1.day)
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
