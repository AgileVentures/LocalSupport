require 'spec_helper'

describe "volunteer_ops/show" do
  let(:org) { double :organization,
    :name => 'Friendly',
    :id => 1
  }
  let(:op) { double :volunteer_op,
    :title => "Honorary treasurer",
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

  it "gets various model attributes" do
    expect(@volunteer_op).to receive :title
    expect(@volunteer_op).to receive :description
    expect(@volunteer_op).to receive(:organization) {org}
    expect(org).to receive(:name)
    render
  end

  it 'hyperlinks the organization' do
    render
    rendered.should have_xpath("//a[contains(.,'#{op.organization.name}') and @href=\"#{organization_path(op.organization.id)}\"]")
  end
end
