require 'faraday'
require 'dotenv'
require 'json'
require './timetree_client.rb'


# 環境変数読み込み
Dotenv.load

# カレンダーID取得
client = TimetreeClient.new
response = client.get('/calendars')

return unless client.success?
calendar_id = response['data'].first['id']

# カレンダー取得
query = { timezone: "Asia/Tokyo" }
response = client.get("/calendars/#{calendar_id}/upcoming_events", query)

return unless client.success?
puts response['data']