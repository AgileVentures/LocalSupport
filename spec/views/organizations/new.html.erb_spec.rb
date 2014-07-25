require 'spec_helper'

describe "organisations/new.html.erb" do
  before(:each) do
    assign(:organisation, stub_model(Organisation).as_new_record)
  end

  it "renders new organisation form" do
    view.lookup_context.prefixes = %w[organisations application]
    render

    rendered.should have_selector("form", :action => organisations_path, :method => "post") do |form|
    end
  end
end
