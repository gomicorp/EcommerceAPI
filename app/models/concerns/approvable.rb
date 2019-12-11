module Approvable
  extend ActiveSupport::Concern

  included do
    has_many :approve_requests, as: :approvable

    def approve_request
      approve_requests.last || approve_requests.create
    end

    def approve_status
      approve_request.status.to_sym
    end
  end
end
