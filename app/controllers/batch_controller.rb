class BatchController < ApplicationController

  def execute
    adapter = HaravanAdapter.new(query_params)
    external_channel_service = ExternalChannelService.new(adapter)

    if external_channel_service.batch_products

    else

    end

  end

  private
  def query_params
    params.permit(:query)
  end
end
