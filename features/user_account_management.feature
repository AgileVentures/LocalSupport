Feature: User Account Management
  As an existing User
  So that I can manage my account
  I want to be able to update my account information

Background:

  Given the following users are registered:
    | email             | password | admin | organization | confirmed_at         |
    | registered_user-1@example.com | pppppppp |       |              | 2007-01-01  10:00:00 |
    | registered_user-2@example.com| pppppppp | true  |              | 2007-01-01  10:00:00 |
    | registered_user-3@example.com| pppppppp | false | Friendly     | 2007-01-01  10:00:00 |


Scenario: Retrieve password
  Given I am on the sign in page
  And I click "Forgot your password?"
  Then I should be on the Forgot your password page
  And I should see "Please enter your email address below"
  When I fill in "user_retrieval_email" with "registered_user-1@example.com"
  And I press "Send me reset password instructions"
  Then I should see "You will receive an email with instructions about how to reset your password in a few minutes."

Scenario: Edit user profile
  Given that I am logged in as any user
  Then I should see "Update account"
  When I click "Update account"
  Then I should be on the Edit account page
  And I should see "Edit User"
  And I should see "Cancel my account"

Scenario: Update user email
  Given I am on the sign in page
  And I sign in as "registered_user-1@example.com" with password "pppppppp"
  And I click "Update account"
  And I fill in "user_email" with "new_email@example.com"
  And I fill in "user_current_password" with "pppppppp"
  And I press "Update"
  Then I should see "You updated your account successfully, but we need to verify your new email address. Please check your email and click on the confirm link to finalize confirming your new email address."

Scenario: Update user email - wrong current password
  Given I am on the sign in page
  And I sign in as "registered_user-1@example.com" with password "pppppppp"
  And I click "Update account"
  And I fill in "user_email" with "new_email@example.com"
  And I fill in "user_current_password" with "12345"
  And I press "Update"
  Then I should see "Current password is invalid"

Scenario: Update user password
  Given I am on the sign in page
  And I sign in as "registered_user-1@example.com" with password "pppppppp"
  And I click "Update account"
  And I fill in "user_password" with "qqqqqqqq"
  And I fill in "user_password_confirmation" with "qqqqqqqq"
  And I fill in "user_current_password" with "pppppppp"
  And I press "Update"
  Then I should see "You updated your account successfully."

  Scenario: Update user password - wrong current password
    Given I am on the sign in page
    And I sign in as "registered_user-1@example.com" with password "pppppppp"
    And I click "Update account"
    And I fill in "user_password" with "qqqqqqqq"
    And I fill in "user_password_confirmation" with "qqqqqqqq"
    And I fill in "user_current_password" with "123456"
    And I press "Update"
    Then I should see "Current password is invalid"

  Scenario: Update user password - wrong confirmation
    Given I am on the sign in page
    And I sign in as "registered_user-1@example.com" with password "pppppppp"
    And I click "Update account"
    And I fill in "user_password" with "qqqqqqqq"
    And I fill in "user_password_confirmation" with "12345"
    And I fill in "user_current_password" with "pppppppp"
    And I press "Update"
    Then I should see "Password doesn't match confirmation"

  Scenario: Update user password - wrong confirmation and wrong current password
    Given I am on the sign in page
    And I sign in as "registered_user-1@example.com" with password "pppppppp"
    And I click "Update account"
    And I fill in "user_password" with "qqqqqqqq"
    And I fill in "user_password_confirmation" with "12345"
    And I fill in "user_current_password" with "12345"
    And I press "Update"
    Then I should see "2 errors prohibited this user from being saved:"
    And I should see "Password doesn't match confirmation"
    And I should see "Current password is invalid"