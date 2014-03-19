require 'spec_helper'

describe "layouts/application.html.erb", :type => :feature do
  context "no user signed-in" do

    before :each do
      view.stub :user_signed_in? => false
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

    it 'renders a cookies choice message when cookies have not been accepted' do
      view.stub(:cookies_accepted?).and_return(false)
      render
      rendered.should have_css("#cookie-message")
      rendered.should have_css("#cookie-message-inner.content")
      rendered.should have_content("We use cookies to give you the best experience on our website.")
      rendered.should have_xpath("//a[@id=\"accept_cookies\"]")
      rendered.should have_xpath("//a[@href=\"#{cookies_allow_path}\"]")
    end

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

     it 'should display a logo linked to the contributors page' do
      render
      doc = Nokogiri::HTML(rendered)
      doc.xpath("//a/img[@alt='Agile Ventures Local Support']/..").first['href'].should eq contributors_path
     end

    it "does not render a new organization link"  do
      view.stub(:user_signed_in? => false)
      render
      rendered.should_not have_xpath("//a[@href='#{new_organization_path}']")
    end
  end

  context "regular user signed-in" do
    before :each do
      view.stub :user_signed_in? => true
      @user = double(User, email: 'normal_user@example.com', admin?: false)
      view.stub :current_user => @user
    end
    it 'renders signed in users email' do
      render
      rendered.should have_link('normal_user@example.com')
    end

    it 'contains log out link' do
      render
      rendered.should have_css("li.dropdown ul.dropdown-menu li a[href=\"#{destroy_user_session_path}\"]")
    end

    it 'admin-only buttons: Organizations and Users' do
      render
      rendered.should_not have_css('.menuOrgs')
      rendered.should_not have_css('.menuUsers')
      @user.stub :admin? => true
      render
      rendered.should have_css('#menuOrgs')
      rendered.should have_css('#menuUsers')
    end

    it "does not render a new organization link"  do
      render
      rendered.should_not have_xpath("//a[@href='#{new_organization_path}']")
    end
  end

  context "admin signed-in" do
    it 'links to new org link in footer' do
      view.stub(:user_signed_in?).and_return(true)
      user = double(User)
      user.stub(:email).and_return('normal_user@example.com')
      user.stub(:admin?).and_return(true)
      view.stub(:current_user).and_return(user)
      render

      rendered.should have_link("New Organisation",href: new_organization_path)
    end
  end
end
