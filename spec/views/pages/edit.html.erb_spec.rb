require 'spec_helper'

describe 'pages/edit.html.erb' do
  before(:each) do
    @page = FactoryGirl.create(:page)
    render
  end

  it 'should render an input text field for page name' do
    expect(rendered).to have_css "input.text_field[value='#{@page.name}']"
  end
end
