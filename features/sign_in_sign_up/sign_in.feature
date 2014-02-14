Feature: Sign in
  As an existing User
  So that I can add charities to the list and make a page for my own charity
  I want to be able to login
  Tracker story ID: https://www.pivotaltracker.com/story/show/47373809

Background:
  Given the following organizations exist:
    | name           | description               | address        | postcode | telephone |
    | Friendly       | Bereavement Counselling   | 34 pinner road | HA1 4HZ  | 020800000 |

  Given the following users are registered:
    | email                     | password | admin | organization | confirmed_at         |
    | normal_user@example.com   | pppppppp |       |              | 2007-01-01  10:00:00 |
    | site_admin@example.com    | pppppppp | true  |              | 2007-01-01  10:00:00 |
    | charity_owner@example.com | pppppppp | false | Friendly     | 2007-01-01  10:00:00 |
  Given I am on the home page
  And cookies are approved

Scenario: Sign in for an existing non-admin user unassociated with any organization
  Given I sign in as "normal_user@example.com" with password "pppppppp"
  Then I should see a link or button "normal_user@example.com"

Scenario: Sign in with wrong password for an existing non-admin user unassociated with any organization
  Given I sign in as "normal_user@example.com" with password "12345"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system."

Scenario: Sign in for an existing non-admin user associated with an organization
  Given I sign in as "charity_owner@example.com" with password "pppppppp"
  Then I should be on the home page
  And I should see a link or button "charity_owner@example.com"

Scenario: Sign in with wrong password for an existing non-admin user associated with an organization
  Given I sign in as "charity_owner@example.com" with password "12345"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system."

Scenario: Sign in for an existing admin user
  Given I sign in as "site_admin@example.com" with password "pppppppp"
  Then I should be on the home page
  And I should see a link or button "site_admin@example.com"

Scenario: Sign in with wrong password for an existing admin user
  Given I sign in as "site_admin@example.com" with password "12345"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system."

Scenario: Sign in for a non-existent user
  Given I sign in as "non-existent_user@example.com" with password "pppppppp"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system"

@javascript
Scenario: Check that login/register toggle works
  # when first opened
  Given I click "Login"
  Then the "loginForm" should be visible
  And the "registerForm" should be not visible
  And I should see "New organisation? Sign-up.."
  # click one way
  Given I click "toggle_link"
  Then the "loginForm" should be not visible
  And the "registerForm" should be visible
  And I should see "Already a member? Login"
  # then click back the other way
  Given I click "toggle_link"
  Then the "loginForm" should be visible
  And the "registerForm" should be not visible
  And I should see "New organisation? Sign-up.."

Scenario: Check class of flash notice  - error
  Given I sign in as "site_admin@example.com" with password "12345"
  Then I should be on the sign in page
  And the "flash_alert" should be "alert-error"


Scenario: Check class of flash notice  - success
  Given I sign in as "site_admin@example.com" with password "pppppppp"
  Then I should be on the home page
  And the "flash_notice" should be "alert-success"
