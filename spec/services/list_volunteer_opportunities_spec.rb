require './app/services/list_volunteer_opportunities'

describe ListVolunteerOpportunities do

  let(:listener) { double :listener }
  let(:organisations) { double :organisations }
  let(:feature) { double :feature}
  let(:http_party) { double :http_party}
  let(:harrow_markers) { '[]'}

  subject(:list_volunteer_opportunities) { ListVolunteerOpportunities.with(listener, organisations, feature, http_party) }

  before { allow(listener).to receive(:build_map_markers).and_return(harrow_markers) }

  context 'doit feature off' do
    before { expect(feature).to receive(:active?).and_return false }
    it 'returns markers and orgs' do
      expect(list_volunteer_opportunities).to eq [harrow_markers, []]
    end
  end

  context 'doit feature on' do
    before { expect(feature).to receive(:active?).and_return true }

    context 'no ops found' do
      let(:response) { double :response, body: '[]' }

      it 'returns markers and orgs' do
        allow(http_party).to receive(:get).and_return(response)
        expect(list_volunteer_opportunities).to eq [harrow_markers, []]
      end
    end

    context 'one page of ops found' do

    end

    context 'two pages of ops found' do

    end
  end

end