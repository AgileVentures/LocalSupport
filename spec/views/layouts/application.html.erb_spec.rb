require 'spec_helper'

describe "layouts/application.html.erb" do
  it "renders site title" do
    render
    rendered.should contain 'Harrow Community Network' 
  end
  it "renders Organization sign in link" do
    render
     rendered.should have_link 'Org Login', :href => user_session_path
  end
  it "renders new Organization sign up link" do
    render
     rendered.should have_link 'New Org?', :href => new_user_registration_path
  end
end
