require './app/services/import_do_it_volunteer_opportunities'
require 'json'

describe ImportDoItVolunteerOpportunities do

  let(:http_party) { double :http_party }
  let(:model_klass) { spy :model_klass }
  let(:url) do
    "#{ImportDoItVolunteerOpportunities::HOST}#{ImportDoItVolunteerOpportunities::HREF}"
  end

  subject(:list_volunteer_opportunities) do
    described_class.with(1.0, http_party, model_klass)
  end

  context 'no ops found' do
    let(:response) { double :response, body: '[]' }

    it 'does not check for the presence and/or create any ops' do
      allow(http_party).to receive(:get).and_return(response)
      list_volunteer_opportunities
      expect(model_klass).not_to have_received(:find_by)
    end
  end

  context 'one page of 16 ops found' do
    let(:response) { double :response, body: File.read('test/fixtures/doit1.json') }

    it 'checks for presence and/or creates 16 ops' do
      allow(http_party).to receive(:get).and_return(response)
      list_volunteer_opportunities
      expect(model_klass).to have_received(:find_or_create_by).exactly(16).times
    end

    it 'queries the the default radius via the doit api' do
      expect(http_party).to receive(:get).with("#{url}1.0").and_return(response)
      list_volunteer_opportunities
    end

    it 'removes all doit ops before re-adding from doit api' do
      allow(http_party).to receive(:get).and_return(response)
      list_volunteer_opportunities
      expect(model_klass).to have_received(:delete_all).with(source: 'doit').ordered
      expect(model_klass).to have_received(:find_or_create_by).exactly(16).times.ordered
    end

    context '3 mile radius query' do
      subject(:list_volunteer_opportunities) do
        described_class.with(3.0, http_party, model_klass)
      end

      it 'queries the 3 mile radius via the doit api' do
        expect(http_party).to receive(:get).with("#{url}3.0").and_return(response)
        list_volunteer_opportunities
      end
    end
  end

  context 'two pages of 30 ops found' do
    let(:response1) { double :response, body: File.read('test/fixtures/doit2.json') }
    let(:response2) { double :response, body: File.read('test/fixtures/doit3.json') }

    it 'checks for presence and/or creates 30 ops' do
      allow(http_party).to receive(:get).and_return(response1, response2)
      list_volunteer_opportunities
      expect(model_klass).to have_received(:find_or_create_by).exactly(30).times
    end

    it 'pages correctly' do
      expect(http_party).to receive(:get).with("#{url}1.0").and_return(response1).ordered
      expect(http_party).to receive(:get).with("#{url}1.0&page=2").and_return(response2).ordered
      list_volunteer_opportunities
    end
  end

end