module Partner
  module Companies
    class ApproveRequestsController < BaseController
      before_action :set_company_approve_request, only: %i[show destroy]

      def index
        @company_approve_requests = Company::ApproveRequest.where(index_params).order(created_at: :desc, id: :desc)
        render json: @company_approve_requests, status: :ok
      end

      def show
        render json: @company_approve_request, status: :ok
      end

      def create
        @company_approve_request = Company::ApproveRequest.new(approve_request_params)

        if @company_approve_request.save
          @company_approve_request.dead_before!
          render json: @company_approve_request, status: :created
        else
          render json: @company_approve_request.errors, status: :unprocessable_entity
        end
      end

      private

      def set_company_approve_request
        @company_approve_request = Company::ApproveRequest.find(params[:id])
      end

      def index_params
        @index_params = params.permit(*Company::ApproveRequest.attribute_names)
        @index_params = @index_params.merge(approvable_id: params[:company_id]) if params[:company_id].present?
        @index_params
      end

      def approve_request_params
        params.require(:approve_request).permit(*(ApproveRequest.attribute_names - %w[id created_at updated_at]))
      end
    end
  end
end
