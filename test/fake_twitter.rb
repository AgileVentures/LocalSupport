require 'sinatra/base'

class FakeTwitter < Sinatra::Base
  get '/twitter/api/update/json' do
    json_response 200, 'tweet_update.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    begin
      File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
