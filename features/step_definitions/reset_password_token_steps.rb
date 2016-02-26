Given(/^I requested a new password too long ago$/) do
  user = FactoryGirl.create(:user)
  @reset_password_token = user.send_reset_password_instructions
  user.reset_password_sent_at = 1.year.ago
  user.save!
end

And(/^I try to reset my password$/) do
  fill_in('user_password', with: 'AbRaCaDaBrA123', match: :prefer_exact)
  fill_in('Confirm new password', with: 'AbRaCaDaBrA123')
  click_button 'Change my password'
end
