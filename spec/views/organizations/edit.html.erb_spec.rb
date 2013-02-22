require 'spec_helper'

describe "organizations/edit.html.erb" do
  before(:each) do
    @organization = assign(:organization, stub_model(Organization,
      :new_record? => false
    ))
  end

  it "renders the edit organization form" do
    view.lookup_context.prefixes = %w[organizations application]
    render

    rendered.should have_selector("form", :action => organization_path(@organization), :method => "post") do |form|
    end
  end
end
