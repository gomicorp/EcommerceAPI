module Partner
  module Office
    class LeftBarController < BaseController
      def notice
        @company_approve_requests = Company::ApproveRequest.alive.pending.count
      end
    end
  end
end
