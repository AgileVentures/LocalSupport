class ImportKCSC
  def self.with(http = HTTParty, model_klass = Organisation)
    new(http, model_klass).send(:run)
  end

  private

  attr_reader :http

  def initialize http, model_klass
    @http = http
    @model_klass = model_klass
  end

  HOST = 'https://www.kcsc.org.uk'
  HREF = '/api/self-care/all?key='

  def run
    @response = http.get "#{HOST}#{HREF}#{ENV['KCSC_API_KEY']}"
    return unless response_has_content?
    @kcsc_contacts = JSON.parse(@response.body)['organisations']
    find_or_create_organisations
  end

  def response_has_content?
    @response.body && @response.body != '{}'
  end

  def find_or_create_organisations
    @kcsc_contacts.each do |kcsc_contact|
      name = kcsc_contact['organisation']['Delivered by-Organization Name'].titleize
      description = kcsc_contact['organisation']['Summary of Activities']
      organisation = @model_klass.find_or_create_by! name: name, description: description
    end
  end

end