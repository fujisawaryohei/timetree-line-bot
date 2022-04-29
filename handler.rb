require 'date'
require 'faraday'
require 'dotenv'
require 'json'
require 'line/bot'
require './timetree_client.rb'
require './line_client.rb'

# https://github.com/serverless/examples/tree/master/aws-ruby-line-bot
def event_notification
  # 環境変数読み込み
  Dotenv.load

  # カレンダーID取得
  timetree_client = TimetreeClient.new
  calendars = timetree_client.get('/calendars')
  
  return unless timetree_client.success?
  calendar_id = calendars['data'].first['id']

  # カレンダー取得
  query = { timezone: "Asia/Tokyo", days: 7, include: 'attendees'}
  events = timetree_client.get("/calendars/#{calendar_id}/upcoming_events", query)
  return unless timetree_client.success?

  # データ整形
  messages = []
  days = ["日", "月", "火", "水", "木", "金", "土"]
  events['data'].each do |event|
    title = event['attributes']['title']
    day = DateTime.parse(event['attributes']['start_at']).strftime('%m月%d日')
    day_of_week = DateTime.parse(event['attributes']['start_at']).strftime("%u")
    start_at_time = DateTime.parse(event['attributes']['start_at']).strftime('%H時%M分')
    end_at_time = DateTime.parse(event['attributes']['end_at']).strftime('%H時%M分')
    
    if start_at_time == end_at_time
      messages.push("予定:\s#{title}\s日にち:#{day}\s#{days[day_of_week.to_i]}曜日\s時間帯:\s終日")
    else
      messages.push("予定:\s#{title}\s日にち:\s#{day}\s#{days[day_of_week.to_i]}曜日\s時間帯:\s#{start_at_time}\s~\s#{end_at_time}")
    end
  end

  # line メッセージ送信
  line_client = LineClient.new(messages)
  line_client.notificate_event

  # Lambda 成功時 レスポンス
  { statusCode: 200, body: JSON.generate({message: "OK"}) }
end