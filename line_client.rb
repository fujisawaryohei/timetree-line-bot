class LineClient

  attr_accessor :messages

  def initialize(messages)
    @messages = messages
  end

  def notificate_event
    message = {
      type: 'text',
      text: messages.join("\n\n")
    }
    client.broadcast(message)
  end

  private

  def client
    client ||= Line::Bot::Client.new { |config|
      config.channel_id = ENV['LINE_CHANNEL_ID']
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
  end
end