class ListVolunteerOpportunities

	def self.run
		host = 'https://api.do-it.org'
    href = "/v1/opportunities\?lat\=51.5978\&lng\=-0.3370\&miles\=0.5 "
    doit_orgs = []
    id = 1
    while href
      url = host + href
      response = HTTParty.get(url)
      if response.body && response.body != '[]'
        resp_items = JSON.parse(response.body)['data']['items']
        resp_items.each do |item|
          org = OpenStruct.new(latitude: item['lat'], longitude: item['lng'], 
                opp_name: item['title'], id: id, 
                description: item['description'], 
                opportunity_id: item['id'], 
                name: item['for_recruiter']['name'], 
                org_link: item['for_recruiter']['slug'])
          doit_orgs.push (org)
          id += 1
        end
        next_page = JSON.parse(response.body)['links']['next']
      end
      href = next_page ? next_page['href'] : nil
    end
    doit_orgs
	end

end