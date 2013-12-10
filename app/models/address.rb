class Address < Struct.new(:value)

  def parse
    address = value.to_s
    postcode = ''
    match = value.to_s.match(/(.*)(,\s*(\w\w\d\s* \d\w\w))/)
    if match
      if match.length == 4
        address = match[1]
        postcode = match[3].to_s
      end
    end
    {:address => address, :postcode => postcode}
  end
end
