Feature: Sign in
  As an existing User
  So that I can add charities to the list and make a page for my own charity
  I want to be able to login

Background:
Given the following users are registered:
| email             | password |
| jcodefx@gmail.com | pppppppp |

Scenario: Sign in for an existing user
  Given I am on the sign in page
  And I sign in as "jcodefx@gmail.com" with password "pppppppp"
  Then I should be on the new charity page
  And I should see "Signed in as jcodefx@gmail.com"
  
Scenario: Sign in for a non-existent user
  Given I am on the sign in page
  And I sign in as "marian.mosley@gmail.com" with password "pppppppp"
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login to the system"

