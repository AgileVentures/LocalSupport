require 'spec_helper'

describe "users/index.html.erb" do
  it 'has a link to approve users' do
    rendered.should have_link "Approve", :href => '#'
  end
end
