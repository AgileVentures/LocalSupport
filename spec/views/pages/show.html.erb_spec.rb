require 'spec_helper'


describe 'pages/show.html.erb' do
  it 'should display a two column layout' do
    render
    rendered.should have_css('#one_column.span12')
    within('#content') do
    end
  end
end


