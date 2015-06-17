def stub_request_with_address(address, body = nil)
  filename = "#{address.gsub(/\s/, '_')}.json"
  filename = File.read "test/fixtures/#{filename}"
  stub_request(:any, /maps\.googleapis\.com/).
      to_return(status => 200, :body => body || filename, :headers => {})
end

