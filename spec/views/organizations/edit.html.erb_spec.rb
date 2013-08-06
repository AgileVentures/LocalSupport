require 'spec_helper'

describe "organizations/edit.html.erb" do
  before(:each) do
    @organization = assign(:organization, stub_model(Organization,
      :new_record? => false, :donation_info => "http://www.friendly.com/donate"
    ))
  end

  it "renders the edit organization form" do
    view.lookup_context.prefixes = %w[organizations application]
    render

    rendered.should have_selector("form", :action => organization_path(@organization), :method => "post") do |form|
    end
  end

  it "renders the donation_info url in edit form" do
    render
    rendered.should have_field :organization_donation_info, 
      :with => "http://www.friendly.com/donate"
  end

  it "renders a form field to add an administrator email" do
    render
    rendered.should have_field :organization_admin_email
  end
end
