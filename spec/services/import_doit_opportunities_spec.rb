require './app/services/import_do_it_volunteer_opportunities'
require 'json'

describe ImportDoItVolunteerOpportunities do

  let(:http_party) { double :http_party }
  let(:model_klass) { spy :model_klass }

  subject(:list_volunteer_opportunities) { described_class.with(0.5,http_party, model_klass) }

  context 'no ops found' do
    let(:response) { double :response, body: '[]' }

    it 'does not check the model klass' do
      allow(http_party).to receive(:get).and_return(response)
      list_volunteer_opportunities
      expect(model_klass).not_to have_received(:find_by)
    end
  end

  context 'one page of ops found' do
    let(:response) { double :response, body: File.read('test/fixtures/doit1.json') }

    it 'checks the model class 16 times' do
      allow(http_party).to receive(:get).and_return(response)
      list_volunteer_opportunities
      expect(model_klass).to have_received(:find_by).exactly(16).times
    end
    it 'queries the proper radius and doit api' do
      expect(http_party).to receive(:get).with('https://api.do-it.org/v1/opportunities?lat=51.5978&lng=-0.3370&miles=0.5').and_return(response)
      list_volunteer_opportunities
    end
  end
  context '3.0 mile radius query' do
    let(:response) { double :response, body: File.read('test/fixtures/doit1.json') }
    subject(:list_volunteer_opportunities) { described_class.with(3.0,http_party, model_klass) }
    it 'queries the proper radius and doit api' do
      expect(http_party).to receive(:get).with('https://api.do-it.org/v1/opportunities?lat=51.5978&lng=-0.3370&miles=3.0').and_return(response)
      list_volunteer_opportunities
    end
  end
  context 'two pages of ops found' do
    let(:response1) { double :response, body: File.read('test/fixtures/doit2.json') }
    let(:response2) { double :response, body: File.read('test/fixtures/doit3.json') }

    it 'returns markers and orgs' do
      allow(http_party).to receive(:get).and_return(response1, response2)
      list_volunteer_opportunities
      expect(model_klass).to have_received(:find_by).exactly(30).times
    end
  end

end