Feature: Admin approve user
  As an Admin
  So that I can approve someone to be able to make edits for a particular charity
    (either by sending a verification e-mail to an e-mail address we know is
     connected to the relevant charity, when someone contacts us saying that
     this is his charity or when a new charity wants to be included on the database)
  I want to be able to verify the organisation/user and give them access to their charity.

  Background: organizations have been added to database
    Given the following users are registered:
    | email             | password | admin | confirmed_at |
    | jcodefx@gmail.com | pppppppp | true  | 2007-01-01  10:00:00 |
    | tansaku@gmail.com | pppppppp | false | 2007-01-01  10:00:00 |

  Scenario: non logged in user should not see new organization link
   Given I am on the home page
   Then I should not see a new organizations link

  Scenario: logged in non-admin user should not see new organization link
    Given I am signed in as a non-admin
    Given I am on the home page
    Then I should not see a new organizations link

  Scenario: logged in admin user should see new organization link
    Given I am signed in as a admin
    Given I am on the home page
    Then I should see a new organizations link

