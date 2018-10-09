require 'rails_helper'

describe ImportOrganisations do
  let(:http_party) { double :http_party }
  let(:model_klass) { spy :model_klass }
  let(:postcode) { 'ha2' }
  let(:url) { 'http://production.charity-api.agileventures.org/charities.json?postcode=ha2' }

  subject(:list_charities) do
    described_class.with(postcode, http_party, model_klass)
  end

  context 'no charities found' do
    let(:response) { double :response, body: '[]' }

    it 'does request data from the api' do
      expect(http_party).to receive(:get).with(url).and_return(response)
      list_charities
    end

    it 'does not create any charities' do
      allow(http_party).to receive(:get).and_return(response)
      list_charities
      expect(model_klass).not_to have_received(:find_or_create_by!)
    end
  end

  context 'charities are found' do
    let(:response) { double :response, body: '[{"name": "Charity One", "regno": "11111" }]' }

    it 'does create a charity' do
      allow(http_party).to receive(:get).and_return(response)
      list_charities
      expect(model_klass).to have_received(:find_or_create_by!).with({ name: 'Charity One'})
    end

    it 'calls the api with the correct URL' do
      expect(http_party).to receive(:get).with(url).and_return(response)
      list_charities
    end

    # todo

    # expand the response mock to be more like the data we get from the API
    # add `regno` and check that it is filtered out

    # write a new unit test to handle multiple charities


  end
end