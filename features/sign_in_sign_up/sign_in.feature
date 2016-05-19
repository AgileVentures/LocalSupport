Feature: Sign in
  As an existing User
  So that I can add charities to the list and make a page for my own charity
  I want to be able to login
  Tracker story ID: https://www.pivotaltracker.com/story/show/47373809

Background:
  Given the following organisations exist:
    | name           | description               | address        | postcode | telephone |
    | Friendly       | Bereavement Counselling   | 34 pinner road | HA1 4HZ  | 020800000 |

  Given the following volunteer opportunities exist:
    | title              | description                                     | organisation              |
    | Litter Box Scooper | Assist with feline sanitation   test@test.com   | Friendly               |
    | Office Support     | Help with printing and copying. http://test.com | Friendly |

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

Scenario: Sign in with wrong password for an existing non-superadmin user unassociated with any organisation
  Given I sign in as "normal_user@example.com" with password "12345"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system."

Scenario: Sign in for an existing non-superadmin user associated with an organisation
  Given I sign in as "charity_owner@example.com" with password "pppppppp"
  Then I should be on the show page for the organisation named "Friendly"
  And I should see a link or button "charity_owner@example.com"

Scenario: Sign in with wrong password for an existing non-superadmin user associated with an organisation
  Given I sign in as "charity_owner@example.com" with password "12345"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system."

Scenario: Sign in for an existing superadmin user
  Given I sign in as "superadmin@example.com" with password "pppppppp"
  Then I should be on the home page
  And I should see a link or button "superadmin@example.com"

Scenario: Sign in for an existing superadmin user after org search
  Given I visit the home page
  And I fill in "Optional Search Text" with "search words" within the main body
  And I press "Submit"
  And I sign in as "superadmin@example.com" with password "pppppppp"
  Then I should be on the organisations search page
  And I should see a link or button "superadmin@example.com"
  And the search box should contain "search words"
  
Scenario: Sign in for an existing superadmin user after vol op search
  Given I visit the volunteer opportunities page
  And I fill in "Search Text" with "search words" within the main body
  And I press "Search"
  And I sign in as "superadmin@example.com" with password "pppppppp"
  Then I should be on the volunteer opportunities search page
  And I should see a link or button "superadmin@example.com"
  And the search box should contain "search words"

Scenario: Sign in for an existing superadmin user after visit vol op page
  Given I visit the show page for the volunteer_op titled "Office Support"
  And I sign in as "superadmin@example.com" with password "pppppppp"
  Then I should be on the show page for the volunteer_op titled "Office Support"
  And I should see a link or button "superadmin@example.com"

Scenario: Sign in with wrong password for an existing superadmin user
  Given I sign in as "superadmin@example.com" with password "12345"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system."

Scenario: Sign in for a non-existent user
  Given I sign in as "non-existent_user@example.com" with password "pppppppp"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system"

@javascript @billy
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

Scenario: Check class of flash notice  - error
  Given I sign in as "superadmin@example.com" with password "12345"
  Then I should be on the sign in page
  And the "flash_alert" should be "alert-error"

Scenario: Check class of flash notice  - success
  Given I sign in as "superadmin@example.com" with password "pppppppp"
  Then I should be on the home page
  And the "flash_notice" should be "alert-success"
