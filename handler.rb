require 'faraday'
require 'dotenv'
require 'json'
require 'line/bot'
require './timetree_client.rb'
require './line_clinet.rb'

# https://github.com/serverless/examples/tree/master/aws-ruby-line-bot
def webhook
  # 環境変数読み込み
  Dotenv.load

  # カレンダーID取得
  timetree_client = TimetreeClient.new
  response = timetree_client.get('/calendars')

  return unless timetree_client.success?
  calendar_id = response['data'].first['id']

  # カレンダー取得
  query = { timezone: "Asia/Tokyo" }
  response = timetree_client.get("/calendars/#{calendar_id}/upcoming_events", query)

  return unless timetree_client.success?

  # line メッセージ送信
  line_client = LineClient.new(event, response)
  line_client.reply

  # Lambda 成功時 レスポンス
  { statusCode: 200, body: JSON.generate({message: "OK"}) }
end