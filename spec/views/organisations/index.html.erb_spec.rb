require 'rails_helper'

describe "organisations/index.html.erb", :type => :view, :js => true do

  let(:org1) do
    stub_model Organisation,:name => 'test', :address => "12 pinner rd", :postcode => "HA1 4HZ",:telephone => "1234", :website => 'http://a.com', :description => 'I am test organisation hahahahahhahaha'
  end

  let(:org2) do
    stub_model Organisation,:name => 'test2', :address => "12 oxford rd", :postcode => "HA1 4HZ", :telephone => "4534", :website => 'http://b.com', :description => 'I am '
  end

  let(:organisations) do
    [org1,org2]
  end

  let(:results) do
    [org1,org2]
  end

  before(:each) do
    assign(:organisations, organisations)
    assign(:results, results)
    assign(:parsed_params, double("ParsedParams", :query_term => 'search'))
    assign(:cat_name_ids, {what: [['Animal Welfare','1'],['Education','2']],
      who: [['Youth','3'],['Ethnic Minorities','4']], how: [['Umbrella','5'],['Individual Grants','6']]})
    assign(:markers, 'my-markers')
    render
  end

  it "renders a search form for delivering subcategory-specific params to the controller" do
    expect(rendered).to have_selector "form input[name='q']"
    expect(rendered).to have_selector "form input[type='submit']"
    expect(rendered).to have_selector "form input[value='search']"
    expect(rendered).to have_content "Optional Search Text"
    expect(rendered).to have_selector "form select[name='what_id']"
    expect(rendered).to have_selector "form select[name='what_id'] option[value='']" do |all_select|
      expect(all_select).to contain("All")
    end
    expect(rendered).to have_selector "form select[name='what_id'] option[value='1']"
    expect(rendered).to have_selector "form select[name='what_id'] option[value='2']"
  end

  it "render organisation names with hyperlinks" do
    organisations.each do |org|
      expect(rendered).to have_link org.name, :href => organisation_path(org.id)
      expect(rendered).to have_content org.description.truncate(128,:omission=>' ...')
    end
  end

  it "does not render addresses and telephone numbers" do
    expect(rendered).not_to have_content org1.address
    expect(rendered).not_to have_content org1.telephone
    expect(rendered).not_to have_content org2.address
    expect(rendered).not_to have_content org2.telephone
  end

  it "does not renders edit and destroy links" do
    expect(rendered).not_to have_link 'Edit'
    expect(rendered).not_to have_link 'Destroy'
    expect(rendered).not_to have_content org2.address
    expect(rendered).not_to have_content org2.telephone
  end

  it 'displays the json for the map script' do
    assign(:footer_page_links, [])
    render template: "organisations/index", layout: "layouts/two_columns_with_map"
    expect(rendered).to include 'my-markers'
  end

  it "displays the javascript for a google map" do
    assign(:footer_page_links, [])
    allow(Page).to receive(:all).and_return []
    render template: "organisations/index", layout: "layouts/application"
    expect(rendered).to include 'google_map.js'
  end

end
