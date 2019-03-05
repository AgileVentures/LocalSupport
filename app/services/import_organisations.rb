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
  CHARITIES_HREF = '/charities.json?postcode='
  CHARITY_OBJECTS_HREF = '/charity_objects.json?postcode='

  def run 
    @response = http.get "#{HOST}#{CHARITIES_HREF}#{@postcode}"
    @charity_objects_response = http.get "#{HOST}#{CHARITY_OBJECTS_HREF}#{@postcode}"
    return unless response_has_content?
    @charities = JSON.parse @response.body
    @charity_objects = JSON.parse @charity_objects_response.body
    find_or_create_charities_and_update
  end
  
  def response_has_content?
    @response.body && @response.body != '[]'
  end
  
  def find_or_create_charities_and_update
    @charities.each do |charity|
      @charity_objects.each do |organisation|
        if organisation['regno'] === charity['regno']
          charity.merge!(description: '') unless charity[:description]
          charity[:description] << "#{organisation['object']}"
        end
      end
      organisation = @model_klass.find_or_create_by! name: charity['name'].titleize 
      organisation.update ({ address: charity['add1'],
                             postcode: charity['postcode'],
                             imported_at: Time.current
                          })
      organisation.update telephone: charity['phone'] if charity['phone']
      organisation.update description: charity[:description] if charity[:description]
    end
  end
end