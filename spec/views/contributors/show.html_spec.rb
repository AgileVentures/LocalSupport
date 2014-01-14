require 'spec_helper'

describe 'contributors/show.html.erb' do
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
       rendered.should have_content contributor['login']
       avatar = contributor['avatar_url']
       link = contributor['html_url']
       rendered.should have_css("a[href='#{link}'] img[src='#{avatar}']")
       rendered.should have_link("Github Profile", href: link)
       rendered.should have_content("Project Contributions: #{contributor['contributions']}")
    end
  end
end