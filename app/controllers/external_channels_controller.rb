class ExternalChannelsController < ApiController
  def initialize
    @error = []
  end

  def code
    ApplicationRecord.country_code = 'vn'
    ExternalChannel::AdapterFactory.adapter('Lazada').set_code(code_params)

    render status: 200, plain: 'get code success'
  end

  def batch_all
    ApplicationRecord.country_code = batch_params[:country_code]
    Channel.all.pluck(:name).each do |channel_name|
      adapter = ExternalChannel::AdapterFactory.get_adapter(channel_name)
      Rails.logger.debug "Request to Channel #{channel_name}"
      
      product_manager = ExternalChannel::ManagerFactory.manager('product', adapter)
      order_manager = ExternalChannel::ManagerFactory.manager('order', adapter)
      
      product_manager.save_all
      order_manager.save_all
    rescue NotImplementedError
      next
    rescue StandardError => e
      Rails.logger.error "#{Time.now} | Error : #{e.inspect} occured\nFIND here:\n#{e.backtrace.last(20)}"
      error << e
    end

    render_json
  end

  def batch
    country_code  = batch_params[:country_code].presence || parameter_missing!
    channel_name  = batch_params[:channel_name].presence || parameter_missing!
    batch_type    = batch_params[:type].presence || parameter_missing!
    query_hash    = batch_params[:query_hash]

    ApplicationRecord.country_code = country_code
    adapter = ExternalChannel::AdapterFactory.adapter(channel_name)
    manager = ExternalChannel::ManagerFactory.manager(batch_type, adapter)

    begin
      manager.save_all(query_hash.to_h)
    rescue StandardError => e
      Rails.logger.error "#{Time.now} | Error : #{e.inspect} occured\nFIND here:\n#{e.backtrace.last(20)}"
      error << e
    end

    render_json
  end

  def order_logs
    item_type     = "ExternalChannel::OrderInfo"
    country_code  = order_log_params[:country_code].presence || "vn"
    order_id      = order_log_params[:order_id].presence || parameter_missing!

    @order_logs = []
    ApplicationRecord.country_code = country_code
    order_info = ExternalChannel::OrderInfo.find_by(external_channel_order_id: order_id)
    return unless order_info

    versions = PaperTrail::Version.where(item_type: item_type, item_id: order_info.id, object: [nil, '']).order('id DESC')
    versions.each do |version|
      # object_changes 는 바로 변경전 값과 변경후 값이 배열로 들어가 있음
      @order_logs << PaperTrail.serializer.load(version.object_changes)
    end

    render json: { order_logs: @order_logs }
  end

  private

  attr_accessor :error

  def code_params
    params.permit('code')
  end

  def batch_params
    params.permit(:country_code, :type, :channel_name, query_hash: {})
  end

  def order_log_params
    params.permit(:order_id)
  end

  def render_json
    if error.empty?
      render status: :no_content, plain: 'success'
    else
      render json: {
        errors: error.map { |e| { message: e.inspect, backtract: e.backtrace } }
      }, status: :bad_request
    end
  end

  def parameter_missing!
    raise(RuntimeError, 'parameter missing')
  end
end
