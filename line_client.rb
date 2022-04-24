class LineClient

  attr_accessor :event, :message

  def initialize(event=nil, message={})
    @event = event
    @message = message
  end

  def reply
    event = JSON.parse(event["body"])
    reply_token = event["events"][0]["replyToken"]
    message = {
      type: 'text',
      text: message
    }
    client.reply_message(reply_token, message)
  end

  private

  def client
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
  end
end