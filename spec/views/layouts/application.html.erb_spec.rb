require 'spec_helper'

describe "layouts/application.html.erb", :type => :feature do
  context "no user signed-in" do

    before :each do
      view.stub(:user_signed_in?).and_return(false)
    end
    it "renders site title" do
      render
      rendered.should contain 'Harrow Community Network'
    end

    it "renders site tag line" do
      render
      rendered.should contain 'Search for local voluntary and community organisations'
    end

    it 'renders Organization sign in form' do
      render
      rendered.should have_selector("form", :id => "loginForm")
    end

    it 'renders sign in form fields correctly' do
       render
       rendered.should have_css("#loginForm input#user_password")
       rendered.should have_css("#loginForm input#user_email")
       rendered.should have_css("#loginForm input#signin")
    end

    it 'renders dropdown menu' do
      render
      rendered.should have_css("#navLogin")
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

    it 'renders a password retrieval link' do
      #<a href="/users/password/new">Forgot your password?</a>
      render
      rendered.should have_css("#menuLogin a[href=\"#{new_user_password_path}\"]")
    end

<<<<<<< HEAD
    it 'renders a cookies choice message when cookies have not been accepted' do
      view.stub(:cookies_accepted?).and_return(false)
      render
      rendered.should have_css(".alert")
      rendered.should have_content("This site uses cookies.")
      rendered.should have_xpath("//a[@id=\"accept_cookies\"]")
      rendered.should have_xpath("//a[@href=\"#{cookies_allow_path}\"]")
      rendered.should have_xpath("//a[@id=\"deny_cookies\"]")
      rendered.should have_xpath("//a[@href=\"#{cookies_deny_path}\"]")
    end

=======
    it 'login form should be visible', :js => true do
      render
      rendered.should_not have_selector("form#loginForm", style: "height: 0px;")
    end

    it 'should not have any flash messages' do
      render
      rendered.should_not have_selector("div.alert")
    end

    it 'should display flash messages when successful' do
      view.stub(:flash).and_return([[:notice,"Yes, we have been successful!!!!!"]])
      render
      rendered.should have_selector("div.alert")
      rendered.should have_content("Yes, we have been successful!!!!!")
      rendered.should have_selector("div.alert-success")
    end

    it 'should display flash messages when failing' do
      view.stub(:flash).and_return([[:error,"No, no, no!"]])
      render
      rendered.should have_selector("div.alert")
      rendered.should have_content("No, no, no!")
      rendered.should have_selector("div.alert-error")
    end
>>>>>>> 85397e9a63067040c0fc9277b8a0ddf5feed7dce

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

    it 'contains log out link' do
      render
      rendered.should have_css("li.dropdown ul.dropdown-menu li a[href=\"#{destroy_user_session_path}\"]")
    end
  end
end
