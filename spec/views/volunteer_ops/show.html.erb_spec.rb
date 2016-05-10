require 'rails_helper'

describe "volunteer_ops/show", :type => :view do
  let(:org) { double :organisation,
    :name => 'Friendly',
    :id => 1
  }
  let(:op) { double :volunteer_op,
    :title => "Honorary treasurer",
    :description => "Great opportunity to build your portfolio!",
    :organisation => org,
    :id => 3
  }
  before(:each) do
    @volunteer_op = assign(:volunteer_op, op)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to have_content op.title
    expect(rendered).to have_content op.description
    expect(rendered).to have_content op.organisation.name
  end

  it "gets various model attributes" do
    expect(@volunteer_op).to receive :title
    expect(@volunteer_op).to receive :description
    expect(@volunteer_op).to receive(:organisation) {org}
    expect(org).to receive(:name)
    render
  end

  it 'hyperlinks the organisation' do
    render
    expect(rendered).
      to have_xpath(
                    "//a[contains(.,'#{op.organisation.name}')" +
                    " and @href=\"#{organisation_path(op.organisation)}\"]")
  end
  context 'with the right to edit' do
    it 'renders an edit button' do
      assign(:editable, true)
      render
      expect(rendered).to have_link 'Edit', edit_volunteer_op_path(id: 3)
    end
  end
  context 'without the right to edit' do
    it 'does not render an edit button' do
      assign(:editable, false)
      render
      expect(rendered).not_to have_link 'Edit', edit_volunteer_op_path(id: 3)
    end
  end
end
