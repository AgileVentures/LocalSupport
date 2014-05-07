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
      end
    end


  context 'Page is hidden' do
    before(:each) { page.stub :link_visible => false }

    it 'has buttons' do
      render
      rendered.within('tbody tr') do |row|
        row.should have_link 'Edit'
        row.should have_link 'Delete'
        end
      end
    end
  end
end

