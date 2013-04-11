Feature: Password retrieval
 As an existing User
 So that I can recover a lost password
 I want to be able to ask that system for a new password

Scenario: Retrieve password for an existing user
  Given PENDING: I am on the sign in page
  When I follow the Forgot your password
  And I fill email with jcodefx@gmail.com
  Then I should see "password sent"
  
Scenario: Retrieve password for a non-existent user
  Given PENDING: I am on the sign in page
  When I follow the Forgot your password
  And I fill email with marian.mosley@gmail.com
  And I should see "I'm sorry, your email is not registered in our system"
  And I should be on the sign up page
