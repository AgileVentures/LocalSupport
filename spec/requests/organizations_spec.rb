require 'spec_helper'

describe "Organizations" do
  describe "GET /organizations" do
    it "renders an in-line script with settings used for interacting with client-side Google Maps API scripts" do
      get organizations_path
      doc = response.body
      doc.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
      doc.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_zoom = true')]"
      doc.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_latitude = 51.5978')]"
      doc.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_longitude = -0.337')]"
      doc.should have_xpath "//script[contains(.,'Gmaps.map.map_options.zoom = 12')]"
      doc.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"

      # debugger
      # puts 'hi'
    end
  end
end
