Then(/^I restore the user with the email "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^the user with email "(.*?)" should be displayed on the all deleted users page$/) do |usr_email|
  visit deleted_users_report_path
  id = User.only_deleted.where(email: usr_email).first.id
  expect(page).to have_css "tr##{id}"
end