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
  | email             | password | admin | organization | confirmed_at         |
  | registered_user-1@example.com | pppppppp |       |              | 2007-01-01  10:00:00 |
  | registered_user-2@example.com| pppppppp | true  |              | 2007-01-01  10:00:00 |
  | registered_user-3@example.com| pppppppp | false | Friendly     | 2007-01-01  10:00:00 |

Scenario: Sign in for an existing non-admin user unassociated with any organization
  Given I am on the sign in page
  And I sign in as "registered_user-1@example.com" with password "pppppppp"
  Then I should see a link or button "registered_user-1@example.com"

Scenario: Sign in for an existing non-admin user associated with an organization
  Given I am on the sign in page
  And I sign in as "registered_user-3@example.com" with password "pppppppp"
  Then I should be on the charity page for "Friendly"
  Then I should see a link or button "registered_user-3@example.com"
  
Scenario: Sign in for an existing admin user
  Given I am on the sign in page
  And I sign in as "registered_user-2@example.com" with password "pppppppp"
  Then I should be on the home page
  Then I should see a link or button "registered_user-2@example.com"

Scenario: Sign in for a non-existent user
  Given I am on the sign in page
  And I sign in as "non-existent_user@example.com" with password "pppppppp"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system"

