module Partner
  module Companies
    class ApproveRequestsController < BaseController
      before_action :set_company_approve_request, only: %i[show destroy]

      def index
        @company_approve_requests = Company::ApproveRequest.where(index_params)
        render json: @company_approve_requests, status: :ok
      end

      def show
        render json: @company_approve_request, status: :ok
      end

      private

      def set_company_approve_request
        @company_approve_request = Company::ApproveRequest.find(params[:id])
      end

      def index_params
        params.permit(*Company::ApproveRequest.attribute_names).merge(
          approvable_id: params[:company_id]
        )
      end
    end
  end
end
