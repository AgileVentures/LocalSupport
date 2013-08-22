require 'spec_helper'

describe 'Address' do

  it 'can extract postcode and address' do
    expect(Address.parse_address('HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 1BA')).to eq({:address => 'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW', :postcode => 'HA1 1BA'})
  end

  it 'can handle postcode extraction when no postcode' do
    expect(Address.parse_address('HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW')).to eq({:address =>'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW', :postcode => ''})
  end

  it 'can handle postcode extraction when nil address' do
    expect(Address.parse_address(nil)).to eq({:address =>'', :postcode => ''})
  end

end
