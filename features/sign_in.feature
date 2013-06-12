Feature: Sign in
  As an existing User
  So that I can add charities to the list and make a page for my own charity
  I want to be able to login

Background:
Given the following organizations exist:
  | name           | description               | address        | postcode | telephone |
  | Friendly       | Bereavement Counselling   | 34 pinner road | HA1 4HZ  | 020800000 |
Given the following users are registered:
| email             | password | admin | organization |
| jcodefx@gmail.com | pppppppp |       |              |
| jcodefx2@gmail.com| pppppppp | true  |              |
| jcodefx3@gmail.com| pppppppp | false | Friendly     |

Scenario: Sign in for an existing non-admin user unassociated with any organization
  Given I am on the sign in page
  And I sign in as "jcodefx@gmail.com" with password "pppppppp"
  Then I should be on the home page
  And I should see "Signed in as jcodefx@gmail.com"

Scenario: Sign in for an existing non-admin user associated with an organization
  Given I am on the sign in page
  And I sign in as "jcodefx3@gmail.com" with password "pppppppp"
  Then I should be on the charity page for "Friendly"
  And I should see "Signed in as jcodefx3@gmail.com"
  
Scenario: Sign in for an existing admin user
  Given I am on the sign in page
  And I sign in as "jcodefx2@gmail.com" with password "pppppppp"
  Then I should be on the home page
  And I should see "Signed in as jcodefx2@gmail.com"

Scenario: Sign in for a non-existent user
  Given I am on the sign in page
  And I sign in as "marian.mosley@gmail.com" with password "pppppppp"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system"

