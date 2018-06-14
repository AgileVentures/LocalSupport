class ImportOrganisations
  def self.with(postcode = 'HA2',
      http = HTTParty,
      model_klass = Organisation)

      response = http.get("http://production.charity-api.agileventures.org/charities.json?postcode=#{postcode}")
      charities = JSON.parse response.body
      if has_content?(response)
        model_klass.find_or_create_by! ({
            "name" => charities.first['name'],
            "description" => 'No Description'
        })
      end

  end


  def self.has_content?(response)
    response.body && response.body != '[]'
  end

end