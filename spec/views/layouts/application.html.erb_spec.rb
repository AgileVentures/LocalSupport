require 'spec_helper'

describe "layouts/application.html.erb" do
 context "no user signed-in" do

    before :each do
      view.stub(:user_signed_in?).and_return(false)
    end
    it "renders site title" do
      render
      rendered.should contain 'Harrow Community Network'
    end

    #Changed the following two to look for sig in and sign up forms instead of links
    it "renders Organization sign in form" do
      render
      rendered.should have_selector("form", :id => "loginForm")
    end

    it 'renders sign in form fields correctly' do
       render
       rendered.should have_css("#loginForm input#user_password")
       rendered.should have_css("#loginForm input#user_email")
       rendered.should have_css("#loginForm input#signin")
    end

    it "renders new Organization sign up form" do
      render
      rendered.should have_selector("form", :id => "registerForm")
    end

    it 'renders sign up form fields correctly' do
      render
      rendered.should have_css("#registerForm input#signup_password")
      rendered.should have_css("#registerForm input#signup_email")
      rendered.should have_css("#registerForm input#signup_password_confirmation")
      rendered.should have_css("#registerForm div input[value=\"Sign up\"]")
    end
 end
end
