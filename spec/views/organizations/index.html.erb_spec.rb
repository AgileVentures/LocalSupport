require 'spec_helper'

describe 'organizations/index.html.erb' do
  let(:org) { stub_model Organization,
                         :id => '1',
                         :name => 'test',
                         :address => '12 pinner rd',
                         :postcode => 'HA1 4HP',
                         :telephone => '1234',
                         :description => 'I am test organization hahahahahhahaha'
  }
  let(:organizations) { [org] }

  before(:each) do
    assign(:organizations, [org])
    assign(:query_term, 'search')
    assign(:category_options, [['Animal Welfare', '1'], ['Education', '2']])
    render
  end

  it 'renders a search form' do
    rendered.should have_selector 'form input[name="q"]'
    rendered.should have_selector 'form input[type="submit"]'
    rendered.should have_selector 'form input[value="search"]'
    rendered.should have_selector 'form input[placeholder="optional search name/description"]'
    rendered.should have_selector 'form select[name="category[id]"]'
    rendered.should have_selector 'form select[name="category[id]"] option[value=""]' do |all_select|
      expect(all_select).to contain('All')
    end
    rendered.should have_selector 'form select[name="category[id]"] option[value="1"]'
    rendered.should have_selector 'form select[name="category[id]"] option[value="2"]'
  end

  it 'render organization names with hyperlinks' do
    rendered.should have_link org.name, :href => organization_path(org.id)
  end

  it 'render organization names with hyperlinks' do
    rendered.should have_content org.description.truncate(128, :omission => ' ...')
  end

  it "displays the javascript for a google map" do
    assign(:json, organizations.to_gmaps4rails)
    assign(:footer_page_links, [])
    Page.stub(:all).and_return []
    render template: "organizations/index", layout: "layouts/application"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_zoom = true')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_latitude = 51.5978')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_longitude = -0.337')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.zoom = 12')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
  end
end
