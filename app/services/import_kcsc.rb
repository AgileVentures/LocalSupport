class ImportKCSC
  def self.with(http = HTTParty, model_klass = Organisation, assoc_model_klass = Service)
    new(http, model_klass, assoc_model_klass).send(:run)
  end

  private

  attr_reader :http, :model_klass, :assoc_model_klass

  def initialize http, model_klass, assoc_model_klass
    @http = http
    @model_klass = model_klass
    @assoc_model_klass = assoc_model_klass
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
      model = model_klass.find_or_initialize_by imported_id: id(contact) 
      save_model_attributes model, contact, address
    end
  end

  def id(contact)
    Integer(contact['organisation']['Contact ID'])
  end

  # ultimately this could be refactored into a separate class
  # but let's get it all working first
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def save_model_attributes model, contact, address 
    model.imported_at = Time.current
    model.imported_from = "#{HOST}#{HREF}"
    model.name = contact['organisation']['Delivered by-Organization Name'].titleize
    model.description = description(contact)
    model.telephone = contact['organisation']['OfficeMain-Phone-General Phone']
    model.email = contact['organisation']['OfficeMain-Email']
    model.website = contact['organisation']['Website']
    model.publish_phone = true
    model.publish_address = true
    # contact['organisation']['Where we work']
    # contact['organisation']['Service Activities']
    model.address = full_address(address)
    model.postcode = address['address']['postal_code'] || ''
    model.latitude = address['address']['Latitude']
    model.longitude = address['address']['Longitude']
    model.geocode if model.not_geocoded?
    model.services << assoc_model_klass.from_model(model)  
    model.save!
  end

  def full_address(address)
    "#{address['address']['Street Address']} #{address['address']['city']}"
  end
  
  def description(contact)
    description = contact['organisation']['Service Activities'] 
    description = contact['organisation']['Summary of Activities'] if description.blank?
    description = '' if description.blank?
    description
  end

end

# hack for one acronym from KCSC, but need a better solution ...
ActiveSupport::Inflector.inflections do |inflect|
  inflect.acronym 'ABI'
end