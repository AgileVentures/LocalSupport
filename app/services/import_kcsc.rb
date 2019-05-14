class ImportKCSC
  def self.with(http = HTTParty, model_klass = Organisation)
    new(http, model_klass).send(:run)
  end

  private

  attr_reader :http, :model_klass

  def initialize http, model_klass
    @http = http
    @model_klass = model_klass
  end

  HOST = 'https://www.kcsc.org.uk'
  HREF = '/api/self-care/all?key='
  ADDRESSES_HREF = '/api/self-care/addresses/all?key='

  def run
    @response = http.get "#{HOST}#{HREF}#{ENV['KCSC_API_KEY']}"
    return unless response_has_content?
    @addresses_response = http.get "#{HOST}#{ADDRESSES_HREF}#{ENV['KCSC_API_KEY']}"
    @kcsc_contacts = JSON.parse(@response.body)['organisations']
    @kcsc_contact_addresses = JSON.parse(@addresses_response.body)['addresses']
    find_or_create_organisations
  end

  def response_has_content?
    @response.body && @response.body != '{}'
  end

  def find_or_create_organisations
    @kcsc_contacts.zip(@kcsc_contact_addresses).each do |contact, address|
      organisation = model_klass.find_or_create_by! args(contact, address)
      organisation.geocode if organisation.not_geocoded?
    end
  end

  def args(contact, address)
    {
      name: contact['organisation']['Delivered by-Organization Name'].titleize,
      description: contact['organisation']['Summary of Activities'],
      postcode: address['address']['postal_code'] || '',
      latitude: address['address']['Latitude'],
      longitude: address['address']['Longitude']
    }
  end

end