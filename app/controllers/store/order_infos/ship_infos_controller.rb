module Store
  module OrderInfos
    class ShipInfosController < CommonController
      before_action :set_ship_info, unless: :bulk_method?, except: :track

      def edit
        if bulk_method?
          @order_infos = OrderInfo.where(id: order_info_ids)
        else
        end
      end

      def update
        if @ship_info.update(ship_info_params)
          if @ship_info.saved_change_to_tracking_number? && @ship_info.tracking_number? && @ship_info.carrier_code?
            agent = Store::GomiBranch::ShippingManager.new @ship_info
            agent.status_task_set('ship_ing')
          end
          render :show, status: :ok
        else
          render json: @ship_info.errors, status: :unprocessable_entity
        end
      end

      # DELETE /partner/brands/1.json
      def destroy
        @ship_info.destroy
        head :no_content
      end

      def status
        to_be_status = params[:status]
        @messages = []
        @successes = []
        if bulk_method?
          @order_infos = OrderInfo.where(id: order_info_ids)
          @order_infos.each do |order_info|
            agent = Store::GomiBranch::ShippingManager.new order_info.ship_info
            @successes << agent.status_task_set(to_be_status)
            @messages << agent.message if agent.message
          end
        else
          agent = Store::GomiBranch::ShippingManager.new @ship_info
          @successes << agent.status_task_set(to_be_status)
          @messages << agent.message
        end

        # response
        if @successes.compact!.include? false
          render json: @ship_info.errors, status: :unprocessable_entity
        else
          render :show, status: :ok
        end
      end

      # [Hooks] batch process end-point
      # by. 젠킨스 아저씨
      #
      # path => track_store_order_info_ship_info_path
      # PATCH /store/order_infos/0/ship_info/track
      def track
        ship_infos = ShipInfo.where(current_status: ShipInfo::StatusLog.where(code: 'ship_ing'))
        agent = Store::GomiBranch::ShippingManager.new
        if agent.update_tracking_info ship_infos.where.not(carrier_code: nil)
          render :show, status: :ok
        else
          render json: agent.errors, status: :not_modified
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_ship_info
        @ship_info = @order_info.ship_info
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def ship_info_params
        params.fetch(:ship_info, {}).permit(*ShipInfo.attribute_names.map(&:to_sym))
      end
    end
  end
end
