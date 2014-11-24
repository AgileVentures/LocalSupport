require 'rails_helper'

describe "organisations/new.html.erb", :type => :view do
  before(:each) do
    assign(:organisation, stub_model(Organisation).as_new_record)
  end

  it "renders new organisation form" do
    view.lookup_context.prefixes = %w[organisations application]
    render
    expect(rendered).to have_xpath("//form[@action='#{organisations_path}'][@method='post']")
  end
end
