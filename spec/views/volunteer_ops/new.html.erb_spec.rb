require 'rails_helper'

describe "volunteer_ops/new", :type => :view do
  let (:organisation) { double :organisation, id: 3 }
  let (:user) { double :user, organisation: organisation } 
  before(:each) do
    assign(:volunteer_op, stub_model(VolunteerOp,
      :title => "MyString",
      :description => "MyText",
      :organisation => nil
    ).as_new_record)
    params[:organisation_id] = 4
  end

  it 'uses a partial that needs local variables' do
    url = organisation_volunteer_ops_path(params[:organisation_id])
    render
    expect(view).to render_template(partial: '_form', locals: { submission_url: url })
  end

  it "renders new volunteer_op form" do
    render
    expect(rendered).to have_xpath("//form[@action='#{organisation_volunteer_ops_path(organisation_id:4)}'][@method='post']")
    expect(rendered).to have_xpath("//form[@action='#{organisation_volunteer_ops_path(organisation_id:4)}'][@method='post']
      //input[@id='volunteer_op_title'][@name='volunteer_op[title]']")
    expect(rendered).to have_xpath("//form[@action='#{organisation_volunteer_ops_path(organisation_id:4)}'][@method='post']
      //textarea[@id='volunteer_op_description'][@name='volunteer_op[description]']")
  end

  it "should have a Create Volunteer Opportunity button" do
    render
    expect(rendered).to have_css 'input[value="Create a Volunteer Opportunity"]'
  end

  it "only has 1 text area and 1 text input" do
    render
    expect(rendered).to have_css("textarea", :count => 1 )
    expect(rendered).to have_css("input[type=text]", :count => 1 )
  end
end
