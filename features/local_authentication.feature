Feature: Sign up
  As a new user 
  So i can authenticate and add new charirites to the list
  I wan to be able to create an account

Background: the user is not registered in the system
  
  Given the following users are registered:
  | email                           | password   |
  | jcodefx@gmail.com               | pppppppp   |

Scenario: Sign up for an existing user
  Given I am on the sign up page
  When I fill email with jcodefx@gmail.com
  And I fill password with pppppppp
  And I fill password confirmation with ppppppp
  And I press submit
  Then I should be on the sign up page
  And I should see "Users exists"
  
Scenario: Sign up for a non-existent user
  Given I am on the sign up page
  When I fill email with marian.mosley@gmail.com
  And I fill password with pppppppp
  And I fill password confirmation with ppppppp
  And I press submit
  Then I should be on the home page
  And I should see "Welcome marian.mosley@gmail.com"

Feature: Sign in
  As an existing User
  So that I can add charities to the list and make a page for my own charity
  I want to be able to login


Scenario: Sign in for an existing user
  Given I am on the sign in page
  When I fill email with jcodefx@gmail.com
  And I fill password with pppppppp
  And I press submit
  Then I should be on the home page
  And I should see "Welcome jcodefx@gmail.com"
  
Scenario: Sign in for a non-existent user
  Given I am on the sign up page
  When I fill email with marian.mosley@gmail.com
  And I fill password with pppppppp
  And I press submit
  Then I should be on the sign in page
  And I should see "I'm sorry, you are not authorized to login the system"

Feature: Sign out
  As a logged-in User
  So that noone else can use my account
  I want to sign out

Scenario: Sign out
  Given that I am logged in as any user
  When I follow sign out
  Then I should be on the public home page

Feature: Password retrieval
 As an existing User
 So that I can recover a lost password
 I want to be able to ask that system for a new password

Scenario: Retrieve password for an existing user
  Given I am on the sign in page
  When I follow the Forgot your password
  And I fill email with jcodefx@gmail.com
  Then I should see "password sent"
  
Scenario: Retrieve password for a non-existent user
  Given I am on the sign in page
  When I follow the Forgot your password
  And I fill email with marian.mosley@gmail.com
  And I should see "I'm sorry, your email is not registered in our system"
  And I should be on the sign up page
