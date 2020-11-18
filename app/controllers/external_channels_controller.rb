class ExternalChannelsController < ApiController
  def code
    render status: 200, plain: 'get code success'
  end

  def batch_all
    ApplicationRecord.country_code = batch_params[:country_code]
    Channel.all.pluck(:name).each do |channel_name|
      adapter = ExternalChannel::AdapterFactory.get_adapter(channel_name)
      Rails.logger.info "Request to Channel #{channel_name}"
      
      product_manager = ExternalChannel::ManagerFactory.get_manager('product', adapter)
      order_manager = ExternalChannel::ManagerFactory.get_manager('order', adapter)
      
      product_manager.save_all
      order_manager.save_all
    rescue NotImplementedError
      next
    rescue StandardError => e
      Rails.logger.error "#{Time.now} | Error : #{e.inspect} occured\nFIND here:\n#{e.backtrace.last(20)}"
    end
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
