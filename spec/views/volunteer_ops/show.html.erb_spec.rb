require 'spec_helper'

describe "volunteer_ops/show" do
	let(:org) { double :organization, name: 'Friendly' }
  let(:op) { double :volunteer_op,
      :title => "Work for Friendly!",
      :description => "Great opportunity to build your portfolio!",
      :organization => org
	}
  before(:each) do
    @volunteer_op = assign(:volunteer_op, op) 
  end

  it "renders attributes in <p>" do
    render
		rendered.should contain op.title
		rendered.should contain op.description
		rendered.should contain op.organization.name
  end
end
