Feature: Sign up
  As a new User
  So that I can add charities to the list and make a page for my own charity
  I want to be able to create a login
  Tracker story ID: https://www.pivotaltracker.com/story/show/47373595

Background:
  Given the following users are registered:
  | email             | password |
  | existent-user1@example.com | pppppppp |
  | existent-user2@example.com | pppppppp |
  And the email queue is clear
  And cookies are approved

@email
Scenario: Sign up for an existing user
  Given I visit the sign up page
  And I sign up as "existent-user1@example.com" with password "pppppppp" and password confirmation "pppppppp"
  Then I should see "Email has already been taken"
  And I should not receive an email
  
@email
Scenario: Sign up for an non-existent user with non-matching password confirmation
  Given I visit the sign up page
  And I sign up as "nonexistent-user2@example.com" with password "pppppppp" and password confirmation "aaaaaaaa"
  Then I should see "Password confirmation doesn't match Password"
  And I should not receive an email
  
@email
Scenario: Sign up for a non-existent user
  Given I visit the sign up page
  And I sign up as "non-existent-user@example.com" with password "ppppp" and password confirmation "ppppp"
  Then I should see "Password is too short (minimum is 8 characters)"
  Given I click "Login"
  And I click "New organisation? Sign up"
  Then I should not see "Email not found in our database. Sorry!"  within "dropdown-menu"
  And I sign up as "non-existent-user@example.com" with password "pppppppp" and password confirmation "pppppppp"
  Then I should be on the home page
  And I should see "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
  And I should receive a "Confirmation instructions" email
  And I click on the confirmation link in the email to "non-existent-user@example.com"
  Then I should be on the sign in page
  And I sign in as "non-existent-user@example.com" with password "pppppppp" on the legacy sign in page
  Then I should be on the home page




