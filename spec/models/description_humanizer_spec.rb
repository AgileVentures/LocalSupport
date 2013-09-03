require 'active_support/all'
require_relative '../../app/models/description_humanizer'

describe DescriptionHumanizer, ".call" do 
  subject { DescriptionHumanizer.call(description) }

  context 'must be able to humanize a description' do 
    let(:description) { 'THIS IS A GOVERNMENT STRING' }
    
    it { should == 'This is a government string' }
  end

  context 'must be able to humanize nil description' do 
    let(:description) { nil }

    it { should == '' }
  end

end
