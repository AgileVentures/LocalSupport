class ImportOrganisations
  def self.with(postcode = 'HA2',
      http = HTTParty,
      model_klass = Organisation)

      response = http.get("http://production.charity-api.agileventures.org/charities.json?postcode=#{postcode}")
      if has_content?(response)
        charities = JSON.parse response.body
        charities.each do |charity|
          organisation = model_klass.find_or_create_by! name: charity['name'], description: 'No Description' 
          organisation.update ({
            address: charity['add1'],
            postcode: charity['postcode'],
            # what other data do want here?
            # which data should be in the block?
          })
          organisation.update telephone: charity['phone'] unless charity['phone'].nil?
        end
      end

  end


  def self.has_content?(response)
    response.body && response.body != '[]'
  end

end