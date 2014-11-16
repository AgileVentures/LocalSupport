require 'spec_helper'

describe "organisations/index.html.erb", :js => true do

  let(:org1) do
    stub_model Organisation,:name => 'test', :address => "12 pinner rd", :postcode => "HA1 4HP",:telephone => "1234", :website => 'http://a.com', :description => 'I am test organisation hahahahahhahaha', :lat => 1, :lng => -1
  end

  let(:org2) do
    stub_model Organisation,:name => 'test2', :address => "12 oxford rd", :postcode => "HA1 4HX", :telephone => "4534", :website => 'http://b.com', :description => 'I am ', :lat => 1, :lng => -1
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
    assign(:query_term,'search')
    organisations.stub(:current_page).and_return(1)
    organisations.stub(:total_pages).and_return(1)
    organisations.stub(:limit_value).and_return(1)
    assign(:category_options, [['Animal Welfare','1'],['Education','2']])
    assign(:markers, 'my-markers')
    render
  end

  it "renders a search form" do
    rendered.should have_selector "form input[name='q']"
    rendered.should have_selector "form input[type='submit']"
    rendered.should have_selector "form input[value='search']"
    rendered.should have_selector "form input[placeholder='optional search name/description']"
    rendered.should have_selector "form select[name='category[id]']"
    rendered.should have_selector "form select[name='category[id]'] option[value='']" do |all_select|
      expect(all_select).to contain("All")
    end
    rendered.should have_selector "form select[name='category[id]'] option[value='1']"
    rendered.should have_selector "form select[name='category[id]'] option[value='2']"
  end

  it "render organisation names with hyperlinks" do
    organisations.each do |org|
      rendered.should have_link org.name, :href => organisation_path(org.id)
      rendered.should have_content org.description.truncate(128,:omission=>' ...')
    end
  end

  it "does not render addresses and telephone numbers" do
    rendered.should_not have_content org1.address
    rendered.should_not have_content org1.telephone
    rendered.should_not have_content org2.address
    rendered.should_not have_content org2.telephone
  end

  it "does not renders edit and destroy links" do
    rendered.should_not have_link 'Edit'
    rendered.should_not have_link 'Destroy'
    rendered.should_not have_content org2.address
    rendered.should_not have_content org2.telephone
  end

  it 'displays the json for the map script' do
    assign(:footer_page_links, [])
    render template: "organisations/index", layout: "layouts/two_columns"
    expect(rendered).to include 'my-markers'
  end

  it "displays the javascript for a google map" do
    assign(:footer_page_links, [])
    Page.stub(:all).and_return []
    render template: "organisations/index", layout: "layouts/application"
    expect(rendered).to include 'map.js'
  end

end
