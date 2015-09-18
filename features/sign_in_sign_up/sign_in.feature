Feature: Sign in
  As an existing User
  So that I can add charities to the list and make a page for my own charity
  I want to be able to login
  Tracker story ID: https://www.pivotaltracker.com/story/show/47373809

Background:
  Given the following organisations exist:
    | name           | description               | address        | postcode | telephone |
    | Friendly       | Bereavement Counselling   | 34 pinner road | HA1 4HZ  | 020800000 |

  Given the following users are registered:
    | email                     | password | superadmin | organisation | confirmed_at         |
    | normal_user@example.com   | pppppppp |       |              | 2007-01-01  10:00:00 |
    | superadmin@example.com    | pppppppp | true  |              | 2007-01-01  10:00:00 |
    | charity_owner@example.com | pppppppp | false | Friendly     | 2007-01-01  10:00:00 |
  Given I visit the home page
  And cookies are approved

@vcr
Scenario: Sign in for an existing non-superadmin user unassociated with any organisation
  Given I sign in as "normal_user@example.com" with password "pppppppp"
  Then I should see a link or button "normal_user@example.com"

@vcr
Scenario: Sign in with wrong password for an existing non-superadmin user unassociated with any organisation
  Given I sign in as "normal_user@example.com" with password "12345"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system."

@vcr
Scenario: Sign in for an existing non-superadmin user associated with an organisation
  Given I sign in as "charity_owner@example.com" with password "pppppppp"
  Then I should be on the show page for the organisation named "Friendly"
  And I should see a link or button "charity_owner@example.com"

@vcr
Scenario: Sign in with wrong password for an existing non-superadmin user associated with an organisation
  Given I sign in as "charity_owner@example.com" with password "12345"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system."

@vcr
Scenario: Sign in for an existing superadmin user
  Given I sign in as "superadmin@example.com" with password "pppppppp"
  Then I should be on the home page
  And I should see a link or button "superadmin@example.com"

@vcr
Scenario: Sign in with wrong password for an existing superadmin user
  Given I sign in as "superadmin@example.com" with password "12345"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system."

@vcr
Scenario: Sign in for a non-existent user
  Given I sign in as "non-existent_user@example.com" with password "pppppppp"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system"

@javascript
@vcr
Scenario: Check that login/register toggle works
  # when first opened
  Given I click "Login"
  Then the "loginForm" should be visible
  And the "registerForm" should be not visible
  And I should see "New organisation? Sign up"
  # click one way
  Given I click "toggle_link"
  Then the "loginForm" should be not visible
  And the "registerForm" should be visible
  And I should see "Already a member? Log in"
  # then click back the other way
  Given I click "toggle_link"
  Then the "loginForm" should be visible
  And the "registerForm" should be not visible
  And I should see "New organisation? Sign up"

@vcr
Scenario: Check class of flash notice  - error
  Given I sign in as "superadmin@example.com" with password "12345"
  Then I should be on the sign in page
  And the "flash_alert" should be "alert-error"

@vcr
Scenario: Check class of flash notice  - success
  Given I sign in as "superadmin@example.com" with password "pppppppp"
  Then I should be on the home page
  And the "flash_notice" should be "alert-success"
