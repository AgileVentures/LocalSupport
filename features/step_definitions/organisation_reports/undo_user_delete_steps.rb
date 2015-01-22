Then(/^I restore the user with the email "(.*?)"$/) do |usr_email|
  id = User.only_deleted.where(email: usr_email).first.id
  within("tr##{id}") do
    click_link "Restore User"
  end
end

Then(/^the user with email "(.*?)" should( not)? be displayed on the all deleted users page$/) do |usr_email, negation|
  visit deleted_users_report_path
  id = User.with_deleted.where(email: usr_email).first.id
  assertion = negation ? :not_to : :to
  expect(page).send(assertion, have_css("tr##{id}"))
end

Given(/^I click on the deleted users link$/) do
  click_link "Deleted Users"
end