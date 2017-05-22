require './app/services/import_reach_skills_volunteer_opportunities'
require 'json'
require 'byebug'

describe ImportReachSkillsVolunteerOpportunities do

	let(:http_party) { double :http_party }
	let(:model_klass) { spy :model_klass }

	subject(:list_volunteer_opportunities) do
		described_class.with(http_party, model_klass)
	end

	context 'no ops found' do
		let(:response) { double :response, body: '[]' }

		it 'does not check for the presence and/or create any ops' do
			allow(http_party).to receive(:get).and_return(response)
			list_volunteer_opportunities
			expect(model_klass).not_to have_received(:find_by)
		end
	end

	context 'one page of 10 ops found' do
		let(:response) { double :response, body: File.read('test/fixtures/reachskills.json') }

		it 'checks for presence and/or creates 10 ops' do
			allow(http_party).to receive(:get).and_return(response)
			list_volunteer_opportunities
			expect(model_klass).to have_received(:find_or_create_by).exactly(10).times
		end

		it 'removes all reachskills ops before re-adding from reachskills api' do
			allow(http_party).to receive(:get).and_return(response)
			list_volunteer_opportunities
			expect(model_klass).to have_received(:delete_all).with(source: 'reachskills').ordered
			expect(model_klass).to have_received(:find_or_create_by).exactly(10).times.ordered
		end
	end
end