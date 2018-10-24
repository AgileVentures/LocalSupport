Given('superadmin already upgraded {string} user') do |email|
  step %(I am signed in as a superadmin)
  step %(I visit the registered users page)
  step %(I click on "Upgrade" for the user "#{email}")
  step %(I sign out)
end
