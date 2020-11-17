class ExternalChannelsController < ApiController
  def code
    render status: 200, plain: 'get code success'
  end

  def batch
    ApplicationRecord.country_code = batch_params[:country_code]
    adapter = ExternalChannel::AdapterFactory.get_adapter(batch_params[:channel_name])
    manager = ExternalChannel::ManagerFactory.get_manager(batch_params[:type], adapter)

    manager.save_all(batch_params[:query_hash])
  end

  private
  def batch_params
    params.permit(:country_code, :type, :channel_name, query_hash: {})
  end
end
