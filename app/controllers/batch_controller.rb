class BatchController < ApplicationController

  def execute
    adapter = HaravanAdapter.new
    external_channel_service = ExternalChannelService.new(adapter)

    if external_channel_service.batch_products(query_params)

    else

    end

  end

  private
  def query_params
    params.permit(:query)
  end
end
