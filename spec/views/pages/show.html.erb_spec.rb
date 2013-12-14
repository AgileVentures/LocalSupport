require 'spec_helper'

=begin
describe 'pages/show.html.erb' do
  it 'should display a two column layout' do
    render
    within('#content') do
      rendered.should have_css('#one_column.span12')
    end
  end
end
=end

