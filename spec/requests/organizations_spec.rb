require 'spec_helper'

describe 'Organizations' do
  describe 'organizations index' do
    it 'renders an in-line script with settings used for interacting with client-side Google Maps API scripts' do
      get organizations_path
      response.body.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
      response.body.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_zoom = true')]"
      response.body.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_latitude = 51.5978')]"
      response.body.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_longitude = -0.337')]"
      response.body.should have_xpath "//script[contains(.,'Gmaps.map.map_options.zoom = 12')]"
      response.body.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
    end
  end
end

describe 'Geocoding Organizations' do
  let(:pinner34) { FactoryGirl.create :organization, address: '34 pinner road', postcode: 'HA1 4HZ' }

  it '' do

    pinner34
  end

  it 'geocodes' do
    pinner34.latitude.should_not be_nil
    pinner34.longitude.should_not be_nil
  end

  it 'geocodes again if the address changes' do
    lat, lng = pinner34.latitude, pinner34.longitude
    pinner34.address = '84 pinner road'
    pinner34.postcode = 'HA1 4HZ'
    pinner34.save!
    pinner34.latitude.should_not be_nil
    pinner34.longitude.should_not be_nil
    pinner34.latitude.should_not eq lat
    pinner34.longitude.should_not eq lng
  end
end
