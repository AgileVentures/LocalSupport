require 'spec_helper'

describe "layouts/application.html.erb", :type => :feature do

  it 'login form should not be visible after toggle', :js => true do
  render
  click_link "Sign-up.."
  rendered.should have_selector("form#loginForm", style: "height: 0px;")
  end

end