class TimetreeClient

  BASE_URL = 'https://timetreeapis.com'

  def initialize
    @response = nil
  end
  
  def get(url, query={})
    @response = connection.get url do |request|
      request.headers["Accept"] = 'application/vnd.timetree.v1+json'
      request.headers["Authorization"] = 'Bearer ' + ENV['TIME_TREE_ACCESS_TOKEN']
      
      unless query.empty?
        query.each{|key, value| request.params[key.to_sym] = value }
      end
    end
    JSON.parse(@response.body)
  end

  def post(url)
    @response = connection.post url do |request|
      request.headers["Accept"] = 'application/vnd.timetree.v1+json'
      request.headers["Authorization"] = 'Bearer ' + ENV['TIME_TREE_ACCESS_TOKEN']
    end
    JSON.parse(@response.body)
  end

  def success?
    @response.success?
  end

  private

  def connection
    @connection ||= Faraday.new(BASE_URL)
  end
end