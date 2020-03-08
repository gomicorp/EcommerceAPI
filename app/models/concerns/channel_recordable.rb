module ChannelRecordable
  extend ActiveSupport::Concern

  included do
    belongs_to :channel
    before_validation :callback_attaching_channel

    scope :channel_of, ->(channel_name) { left_joins(:channel).where(channels: { name: channel_name }) }
    scope :default_channel, -> { where(channel: Channel.default_channel) }
  end

  private

  def callback_attaching_channel
    self.channel_id ||= Channel.default_channel.id
  end
end
