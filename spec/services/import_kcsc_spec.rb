require 'rails_helper'

describe ImportKCSC do
  let(:http_party) { double :http_party }
  let(:url) {"#{ImportKCSC::HOST}#{ImportKCSC::HREF}#{ENV['KCSC_API_KEY']}"}
  let(:model_klass) { spy :model_klass }

  subject(:import_kcsc) { described_class.with(http_party, model_klass) }

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

    it 'checks for presence and/or creates 2 organisations' do
      allow(http_party).to receive(:get).and_return(response)
      import_kcsc
      expect(model_klass).to have_received(:find_or_create_by!).exactly(2).times
    end
  end
end