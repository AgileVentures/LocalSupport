class Address
  def self.parse_address(address_with_trailing_postcode)
    address = address_with_trailing_postcode.to_s
    postcode = ''
    match = address_with_trailing_postcode.to_s.match(/(.*)(,\s*(\w\w\d\s* \d\w\w))/)
    if match
      if match.length == 4
        address = match[1]
        postcode = match[3].to_s
      end
    end
    {:address => address, :postcode => postcode}
  end
end