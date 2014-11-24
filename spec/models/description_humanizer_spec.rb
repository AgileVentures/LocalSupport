require 'active_support/all'
require_relative '../../app/models/description_humanizer'

describe DescriptionHumanizer, ".call", :type => :model do 
  subject { DescriptionHumanizer.call(description) }

  context 'must be able to humanize a description' do 
    let(:description) { 'THIS IS A GOVERNMENT STRING' }
    
    it { is_expected.to eq('This is a government string') }
  end

  context 'must be able to humanize nil description' do 
    let(:description) { nil }

    it { is_expected.to eq('') }
  end

end
