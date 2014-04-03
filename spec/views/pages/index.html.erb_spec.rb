require 'spec_helper'

describe "pages/index.html.erb" do
  let(:page) { mock_model Page,
                      {
                          id: 'about',
                          name: 'About',
                          permalink: 'about',
                          content: 'blah blah',
                          created_at: 'Y2K',
                          link_visible: true
                      }
  }
  before(:each) { assign(:pages, [page]) }

  context 'Page is shown' do

    it 'has buttons' do
      render
      rendered.within('tbody tr') do |row|
        row.should have_link 'Edit'
        row.should have_link 'Delete'
        row.should have_link 'Hide link'
      end
    end

    it 'has a form for the page' do
      render
      debugger
      rendered.should have_selector('form', :action=>"/"+page.permalink)
    end

    it 'has a "Hide link" button that submits a "put" form for the page' do
      pending
      render
      rendered.should have_selector('input', :action=>"/"+page.permalink)
#      rendered.should have_link('Hide link', :href=>"/page/1/update")
    end

    it 'has a "Hide link" button that clears the page\'s link_visible flag' do
      pending
    end
  end

  context 'Page is hidden' do
    before(:each) { page.stub :link_visible => false }

    it 'has buttons' do
      render
      rendered.within('tbody tr') do |row|
        row.should have_link 'Edit'
        row.should have_link 'Delete'
        row.should have_link 'Show link'
      end
    end
  end
end
