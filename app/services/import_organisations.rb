class ImportOrganisations
  def self.with(postcode = 'HA2',
                http = HTTParty,
                model_klass = Organisation)
      new(postcode, http, model_klass).send(:run)
  end

  private
  
  attr_reader :postcode, :http, :model_klass
  
  def initialize postcode, http, model_klass
    @postcode = postcode
    @http = http
    @model_klass = model_klass
  end
  
  HOST = 'http://production.charity-api.agileventures.org'
  HREF = '/charities.json?postcode='

  def run 
    @response = http.get "#{HOST}#{HREF}#{@postcode}"
    return unless response_has_content?
    @charities = JSON.parse @response.body
    find_or_create_charities_and_update
  end
  
  def response_has_content?
    @response.body && @response.body != '[]'
  end
  
  def find_or_create_charities_and_update
    @charities.each do |charity|
      organisation = @model_klass.find_or_create_by! name: charity['name'].titleize 
      organisation.update ({ address: charity['add1'],
                             postcode: charity['postcode'],
                             imported_at: Time.current
                          })
      organisation.update telephone: charity['phone'] if charity['phone']
    end
  end
end