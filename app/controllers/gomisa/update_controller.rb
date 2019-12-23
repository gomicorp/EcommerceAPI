module Gomisa
  class UpdateController < BaseController
    # GET /gomisa/updates.json
    def index
      @service = Zoho::MigrationService.new
      @service.call

      render json: { content: { result: "successful" } }, status: :ok
    end
  end
end
