require 'sinatra/base'

# http://robots.thoughtbot.com/how-to-stub-external-services-in-tests

class FakeGoogleGeocode < Sinatra::Base
  get '/maps/api/geocode/json' do
    json_response 200, filename
  end

  private

  def filename
    # {"address"=>"34 pinner road, HA1 4HZ"}
    "#{params[:address].downcase.rstrip.gsub(/,/,'').gsub(/\s/, '_')}.json"
  end

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    begin
      File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
    # Errno::ENOENT - No such file or directory
    rescue Errno::ENOENT
      { "results" => [],
        "status" => "OVER_QUERY_LIMIT" }.to_json
    end
  end
end
