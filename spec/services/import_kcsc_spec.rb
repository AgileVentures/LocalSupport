require 'rails_helper'

describe ImportKCSC do
  let(:http_party) { double :http_party }
  let(:key) {ENV['KCSC_API_KEY']}
  let(:url) {"#{ImportKCSC::HOST}#{ImportKCSC::HREF}#{key}"}
  let(:address_url) {"#{ImportKCSC::HOST}#{ImportKCSC::ADDRESSES_HREF}#{key}"}
  let(:model_klass) { spy :model_klass }
  let(:assoc_model_klass) { spy :assoc_model_klass }

  subject(:import_kcsc) { described_class.with(http_party, model_klass, assoc_model_klass) }

  context 'nothing to import' do
    let(:response) {double :response, body: '{}'} 

    it 'does request data from the api' do
      expect(http_party).to receive(:get).with(url).and_return(response)
      import_kcsc
    end

    it 'does not create any organisations' do
      allow(http_party).to receive(:get).and_return(response)
      import_kcsc
      expect(model_klass).not_to have_received(:find_or_create_by!) 
    end
  end
  
  context 'list to import is returned' do
    let(:json_file) {'test/fixtures/kcsc_self_care.json'}
    let(:response) { double :response, body: File.read(json_file) }
    let(:address_json_file) {'test/fixtures/kcsc_self_care_addresses.json'}
    let(:address_response) { double :response, body: File.read(address_json_file) }

    it 'checks for presence and/or creates 2 organisations' do
      allow(http_party).to receive(:get).with(url).and_return(response)
      allow(http_party).to receive(:get).with(address_url).and_return(address_response)
      import_kcsc
      expect(model_klass).to have_received(:find_or_initialize_by).exactly(2).times
    end

    it 'requests data from the addresses endpoint' do
      allow(http_party).to receive(:get).with(url).and_return(response)
      expect(http_party).to receive(:get).with(address_url).and_return(address_response)
      import_kcsc
    end
  end
end