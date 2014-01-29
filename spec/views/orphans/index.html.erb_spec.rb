require 'spec_helper'

describe "orphans/index.html.erb" do
  let(:org1) { stub_model Organization, name: 'test', address: '12 pinner rd', email: 'hello@there.com', users: [] }
  let(:null_user) { stub_model NullObject }
  before(:each) { assign(:families, [[org1, null_user]]) }

  it "should display a generate user button" do
    render
    rendered.should have_content "Generate User"
  end

end