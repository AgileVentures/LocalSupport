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
  context "user signed-in" do

    before :each do
      view.stub(:user_signed_in?).and_return(true)
      user = double(User)
      user.stub(:email).and_return('normal_user@example.com')
      view.stub(:current_user).and_return(user)
    end
    it 'renders signed in users email' do
      render
      rendered.should have_link('normal_user@example.com')
    end
  end
end
