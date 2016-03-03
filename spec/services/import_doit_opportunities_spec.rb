require './app/services/import_do_it_volunteer_opportunities'
require 'json'

describe ImportDoItVolunteerOpportunities do

  let(:http_party) { double :http_party}

  subject(:list_volunteer_opportunities) { described_class.with(http_party) }

  # context 'no ops found' do
  #   let(:response) { double :response, body: '[]' }
  #
  #   it 'returns markers and orgs' do
  #     allow(http_party).to receive(:get).and_return(response)
  #     expect(list_volunteer_opportunities).to eq [harrow_markers, []]
  #   end
  # end
  #
  # context 'one page of ops found' do
  #   let(:response) { double :response, body: File.read('test/fixtures/doit1.json') }
  #
  #   it 'returns markers and orgs' do
  #     allow(http_party).to receive(:get).and_return(response)
  #     expect(list_volunteer_opportunities[1].length).to eq 16
  #   end
  # end
  #
  # context 'two pages of ops found' do
  #   let(:response1) { double :response, body: File.read('test/fixtures/doit2.json') }
  #   let(:response2) { double :response, body: File.read('test/fixtures/doit3.json') }
  #
  #   it 'returns markers and orgs' do
  #     allow(http_party).to receive(:get).and_return(response1, response2)
  #     expect(list_volunteer_opportunities[1].length).to eq 30
  #   end
  # end

end