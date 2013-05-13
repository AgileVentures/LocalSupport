Feature: Sign in
  As an new User
  So that I can add charities to the list and make a page for my own charity
  I want to be able to icreate a login

Background:
Given the following users are registered:
| email             | password |
| jcodefx@gmail.com | pppppppp |

Scenario: Sign up for an existing user
  Given I am on the sign up page
  And I sign up as "jcodefx@gmail.com" with password "pppppppp" and password confirmation "pppppppp"
  Then I should see "Email has already been taken"
  
Scenario: Sign up for a non-existent user
  Given I am on the sign up page
  And I sign up as "marian.mosley@gmail.com" with password "pppppppp" and password confirmation "pppppppp"
  Then I should be on the new charity page
  And I should see "Signed in as marian.mosley@gmail.com"

Scenario: Sign up for an non-existent user with non-matching password confirmation
  Given I am on the sign up page
  And I sign up as "jcodefx@gmail.com" with password "pppppppp" and password confirmation "aaaaaaaa"
  Then I should see "Password doesn't match confirmation"
  
