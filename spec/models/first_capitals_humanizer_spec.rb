require 'active_support/all'
require_relative '../../app/models/first_capitals_humanizer'
describe FirstCapitalsHumanizer, ".call", :type => :model do 
  let(:phrase) { 'SOME WORDS FOR TESTING' }

  context 'should humanize a phrase' do 
    subject { FirstCapitalsHumanizer.call(phrase) }

    it { is_expected.to eq('Some Words For Testing') }
  end
end
