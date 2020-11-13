class ExternalChannelsController < ApiController
  def code
    render status: 200, plain: 'get code success'
  end

  def batch
    adapter = ExternalChannel::AdapterFactory.get_adapter(batch_params[:channel_name])
    manager = ExternalChannel::ManagerFactory.get_manager(batch_params[:type], adapter)

    manager.save_all(batch_params[:query_hash])
  end

  private
  def batch_params
    params.permit(:type, :channel_name, :query_hash)
  end
end
