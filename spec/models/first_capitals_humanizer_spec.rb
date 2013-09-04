require 'active_support/all'
require_relative '../../app/models/first_capitals_humanizer'
describe FirstCapitalsHumanizer, ".call" do 
  let(:phrase) { 'SOME WORDS FOR TESTING' }

  context 'should humanize a phrase' do 
    subject { FirstCapitalsHumanizer.call(phrase) }

    it { should == 'Some Words For Testing' }
  end
end
