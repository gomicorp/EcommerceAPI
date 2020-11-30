module Store
  class OrderInfosController < BaseController
    before_action :set_order_info, only: %i[edit update destroy show]

    # GET /partner/brands
    # GET /partner/brands.json
    def index
      @order_infos = OrderInfo.all
    end

    # GET /partner/brands/1.json
    def show
    end

    # POST /partner/brands.json
    def create
      @order_info = OrderInfo.new(order_info_params)

      if @order_info.save
        render :show, status: :created
      else
        render json: @order_info.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /partner/brands/1.json
    def update
      @order_info.assign_attributes(order_info_params)

      if @order_info.save
        render :show, status: :ok
      else
        render json: @order_info.errors, status: :unprocessable_entity
      end
    end

    # DELETE /partner/brands/1.json
    def destroy
      @order_info.destroy
      head :no_content
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_order_info
      @order_info = OrderInfo.where(id: params[:id]).first
      @order_info ||= OrderInfo.find_by!(enc_id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_info_params
      params.require(:order_info).permit(*OrderInfo.attribute_names)
    end

    def query_param
      params.permit(*OrderInfo.attribute_names, id: [])
    end
  end
end
