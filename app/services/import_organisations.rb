class ImportOrganisations
  def self.with(postcode = 'HA2',
      http = HTTParty,
      model_klass = Organisation)

      response = http.get("http://production.charity-api.agileventures.org/charities.json?postcode=#{postcode}")
      # will need to loop at some point
      charities = JSON.parse response.body # this should be inside the has_content? check
      if has_content?(response)
        model_klass.find_or_create_by! ({
            "name" => charities.first['name'],
            "description" => 'No Description'
            # what other data do want here?
            # which data should be in the block?
        })
      end

  end


  def self.has_content?(response)
    response.body && response.body != '[]'
  end

end