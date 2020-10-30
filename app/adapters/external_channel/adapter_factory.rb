module ExternalChannel
  class AdapterFactory
    def initialize(channel_name)
      case channel_name
      when 'haravan'
        ExternalChannel::HaravanAdapter.new
      when 'tiki'
        ExternalChannel::TikiAdapter.new
      else
        raise NotImplementedError('Requested Data Is Not Supported!')
      end
    end
  end
end