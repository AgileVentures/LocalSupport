require 'rails_helper'

describe 'contributors/show.html.erb', :type => :view do
  before :each do
    @contributors = [
        {'login' => 'thomas', 'avatar_url' => 'http://example.com/thomas.png', 'html_url' => 'http://github.com/thomas', 'contributions' => 7},
        {'login' => 'john', 'avatar_url' => 'http://example.com/john.png', 'html_url' => 'http://github.com/john', 'contributions' => 9}
    ]

    assign(:contributors, @contributors )
  end

  it 'should display each contributor and their contributions' do
    render
    @contributors.each do |contributor|
       expect(rendered).to have_content contributor['login']
       avatar = contributor['avatar_url']
       link = contributor['html_url']
       expect(rendered).to have_css("a[href='#{link}'] img[src='#{avatar}']")
       expect(rendered).to have_link("Github Profile", href: link)
       expect(rendered).to have_content("Project Contributions: #{contributor['contributions']}")
    end
  end
end
