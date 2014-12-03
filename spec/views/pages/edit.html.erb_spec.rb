require 'rails_helper'

describe 'pages/edit.html.erb', :type => :view do
  before(:each) do
    @page = FactoryGirl.create(:page)
    render
  end

  it 'has a pre-populated input text field for page name' do
    expect(rendered).to have_css \
      "input[type=text][name='page[name]'][value='#{@page.name}']"
  end

  describe 'input check box for page link_visible' do
    it "is correctly named" do
      expect(rendered).to have_css \
        "input[type=checkbox][name='page[link_visible]']"
    end
    it 'has a corresponding label' do
      expect(rendered).to have_css \
        "label[for=page_link_visible]"
    end
    it 'visually reflects the state of the model' do
      # @page.link_visible starts this example as true
      expect(rendered).to have_css \
      "input[type=checkbox][name='page[link_visible]'][checked='checked']" 
      @page.link_visible = false
      rendered = render
      expect(rendered).to have_css \
      "input[type=checkbox][name='page[link_visible]']"
      expect(rendered).not_to have_css \
      "input[type=checkbox][name='page[link_visible]'][checked='checked']"
    end
    it 'has a corresponding hidden input to clear the flag' do
      expect(rendered).to have_css "input[type=hidden][name='page[link_visible]'][value='0']"
    end
  end
end

