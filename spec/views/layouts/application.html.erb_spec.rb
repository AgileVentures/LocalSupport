require 'spec_helper'

describe "layouts/application.html.erb" do
  it "renders site title" do
    render
    rendered.should contain 'Harrow Community Network' 
  end

  #Changed the following two to look for sig in and sign up forms instead of links
  it "renders Organization sign in link" do
    render
    rendered.should have_selector("form", :id => "loginForm")
  end

  it "renders new Organization sign up link" do
    render
    rendered.should have_selector("form", :id => "registerForm")
  end
end
