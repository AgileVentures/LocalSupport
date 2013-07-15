Feature: Password retrieval
  As an existing User
  So that I can recover a lost password
  I want to be able to ask that system for a new password
  Tracker story ID: https://www.pivotaltracker.com/story/show/47376361

Background:
  Given the following users are registered:
  | email             | password |
  | registered-user@example.com | pppppppp |

@email
Scenario: Retrieve password for an existing user
  Given I am on the sign in page
  When I follow "Forgot your password?"
  And I fill in "Email" with "registered-user@example.com"
  And I press "Send me reset password instructions"
  Then I should see "You will receive an email with instructions about how to reset your password in a few minutes."
  And I should receive a "Reset password instructions" email

@email
Scenario: Retrieve password for a non-existent user
  Given I am on the sign in page
  When I follow "Forgot your password?"
  And I fill in "Email" with "non-existent_user@example.com"
  And I press "Send me reset password instructions"
  And I should see "Email not found in our database. Sorry!"
  And I should not receive an email
  #And I should be on the sign up page 
