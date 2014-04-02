require_relative '../../app/models/address'
require 'spec_helper'

describe Address, "#parse" do
  let(:address) { Address.new(address_to_parse) }
  subject { address.parse }

  context 'must be able to extract postcode and address' do
    let(:address_to_parse) do 
      'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 1BA'
    end

    it { should eql(:address => 'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW', :postcode => 'HA1 1BA') }
  end

  context 'must be able to handle postcode extraction when no postcode' do
    let(:address_to_parse) do 
      'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW'
    end
    it { should eql(:address =>'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW', :postcode => '') }
  end

  context 'must be able to handle postcode extraction when nil address' do
    let(:address_to_parse) { nil } 

    it { should eql(:address =>'', :postcode => '') }
  end
end