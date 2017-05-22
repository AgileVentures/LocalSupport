require_relative '../../app/models/address'

describe Address, "#parse", :type => :model do 
  let(:address) { Address.new(address_to_parse) }
  subject { address.parse }

  context 'must be able to extract postcode and address' do
    let(:address_to_parse) do 
      'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 4HZ'
    end

    it { is_expected.to eql(:address => 'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW', :postcode => 'HA1 4HZ') }
  end

  context 'must be able to handle postcode extraction when no postcode' do
    let(:address_to_parse) do 
      'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW'
    end
    it { is_expected.to eql(:address =>'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW', :postcode => '') }
  end

  context 'must be able to handle postcode extraction when nil address' do
    let(:address_to_parse) { nil } 

    it { is_expected.to eql(:address =>'', :postcode => '') }
  end
end

