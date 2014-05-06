require 'spec_helper'

describe 'layouts/application.html.erb', :type => :feature do
  let(:page_one)   {{:name => 'About Us',   :permalink => 'about'      }}
  let(:page_two)   {{:name => 'Contact',    :permalink => 'contact'    }}
  let(:page_three) {{:name => 'Disclaimer', :permalink => 'disclaimer' }}
  let(:user) { double :user, email: 'user@example.com' }
  before :each do
    @pages = [page_one, page_two]
    @absent_pages = [page_three]
    assign(:footer_page_links, @pages)
  end
  context 'no user signed-in' do

    before :each do
      view.stub :user_signed_in? => false
    end

    it 'renders site title' do
      render
      expect(rendered).to contain 'Harrow Community Network'
    end

    it 'renders site tag line' do
      render
      expect(rendered).to contain 'Search for local voluntary and community organisations'
    end

    it 'renders Organization sign in form' do
      render
      expect(rendered).to have_selector('form', :id => 'loginForm')
    end

    it 'renders sign in form fields correctly' do
      render
      expect(rendered).to have_css('#loginForm input#user_password')
      expect(rendered).to have_css('#loginForm input#user_email')
      expect(rendered).to have_css('#loginForm input#signin')
    end

    it 'renders dropdown menu' do
      render
      expect(rendered).to have_css('#navLogin')
    end

    it 'renders new Organization sign up form' do
      render
      expect(rendered).to have_selector('form', :id => 'registerForm')
    end

    it 'renders sign up form fields correctly' do
      render
      expect(rendered).to have_css('#registerForm input#signup_password')
      expect(rendered).to have_css('#registerForm input#signup_email')
      expect(rendered).to have_css('#registerForm input#signup_password_confirmation')
      expect(rendered).to have_css('#registerForm div input[value=\'Sign up\']')
    end

    it 'renders a password retrieval link' do
      #<a href="/users/password/new">Forgot your password?</a>
      render
      expect(rendered).to have_css("#menuLogin a[href=\"#{new_user_password_path}\"]")
    end

    it 'renders a cookies choice message when cookies have not been accepted' do
      view.stub(:cookies_accepted?).and_return(false)
      render
      expect(rendered).to have_css('#cookie-message')
      expect(rendered).to have_css('#cookie-message-inner.content')
      expect(rendered).to have_content \
        'We use cookies to give you the best experience on our website.'
      expect(rendered).to have_xpath("//a[@id=\"accept_cookies\"]")
      expect(rendered).to have_xpath("//a[@href=\"#{cookies_allow_path}\"]")
    end

    it 'renders an Organisations link' do
      render
      expect(rendered).to have_xpath("//div[@id=\"navbar\"]//a[@href=\"#{organizations_path}\"]")
    end

    it 'renders a Volunteers link' do
      render
      expect(rendered).to have_xpath("//div[@id=\"navbar\"]//a[@href=\"#{volunteer_ops_path}\"]")
    end
    
    it 'login form should be visible', :js => true do
      render
      expect(rendered).not_to have_selector('form#loginForm', style: 'height: 0px;')
    end

    it 'should not have any flash messages' do
      render
      expect(rendered).not_to have_selector('div.alert')
    end

    it 'should display flash messages when successful' do
      view.stub(:flash).and_return([[:notice, 'Yes, we have been successful!!!!!']])
      render
      expect(rendered).to have_selector('div.alert')
      expect(rendered).to have_content('Yes, we have been successful!!!!!')
      expect(rendered).to have_selector('div.alert-success')
    end

    it 'should display flash messages when failing' do
      view.stub(:flash).and_return([[:error, 'No, no, no!']])
      render
      expect(rendered).to have_selector('div.alert')
      expect(rendered).to have_content('No, no, no!')
      expect(rendered).to have_selector('div.alert-error')
    end

    it 'should display a logo linked to the contributors page' do
      render
      rendered.within("a[href='#{contributors_path}']") do |hyperlink|
        hyperlink.should have_css "img[@alt='Agile Ventures']"
      end
    end

    it 'should display a logo linked to the ninefold page' do
      render
      rendered.within("a[href='https://ninefold.com']") do |hyperlink|
        hyperlink.should have_css "img[@alt='Ninefold']"
      end
    end

    it 'does not render a new organization link' do
      view.stub(:user_signed_in? => false)
      render
      expect(rendered).not_to have_xpath("//a[@href='#{new_organization_path}']")
    end

    context 'footer links to pages' do
      it 'shows no links to pages when there are no pages' do
        @absent_pages = [page_one, page_two, page_three]
        assign(:footer_page_links, [])
        render
        @absent_pages.each do |page|
          expect(rendered).not_to have_link(page[:name], 
                                            :href => page_path(page[:permalink]))
        end
      end

      it 'shows a link to all of the editable pages' do
        render
        @pages.each do |page|
          expect(rendered).to have_link(page[:name], 
                                        :href => page_path(page[:permalink]))
        end
        @absent_pages.each do |page|
          expect(rendered).not_to have_link(page[:name], 
                                            :href => page_path(page[:permalink]))
        end
      end
    end
  end

  context 'regular user signed-in' do
    before do
      user.stub(:admin?) { false }
      view.stub(:current_user) { user }
      render
    end

    it 'renders signed in users email' do
      expect(rendered).to have_link('user@example.com')
    end

    it 'contains log out link' do
      expect(rendered).to \
        have_css("li.dropdown ul.dropdown-menu li a[href=\"#{destroy_user_session_path}\"]")
    end

    it 'should not see admin-only dropdown' do
      expect(rendered).not_to have_css('#menuAdmin')
    end

    it 'does not render a new organization link' do
      expect(rendered).not_to have_xpath("//a[@href='#{new_organization_path}']")
    end
  end

  context 'admin signed-in' do
    before(:each) do
      user.stub(:admin?) { true }
      view.stub(:current_user) { user }
      render
    end

    it 'links to new org link in footer' do
      expect(rendered).to have_link('New Organisation', href: new_organization_path)
    end

    it 'should see admin-only dropdown' do
      rendered.within('#menuAdmin') do |menu|
        menu.should have_link 'Organisations Without Users', :href => organizations_report_path
        menu.should have_link 'All Users', :href => users_report_path
        menu.should have_link 'Invited Users', :href => invited_users_report_path
      end
    end
  end
end

