Feature: Manage charity admins
  As a site admin
  So that users can keep their charity information up to date
  I want to manage the administrators associated with charities

Background: organizations have been added to database
    Given the following organizations exist:
      | name           | description             | address        | postcode | telephone |
      | Friendly       | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 |
      | Friendly Clone | Quite Friendly!         | 30 pinner road | HA1 4HZ  | 020800010 |
    And the following users are registered:
      | email             | password | admin | confirmed_at |  organization |
      | registered-user-1@example.com | pppppppp | true  | 2007-01-01  10:00:00 |  Friendly |
      | registered-user-2@example.com | pppppppp | false | 2007-01-01  10:00:00 |           |
    And cookies are approved

 Scenario: Existing charity admin appears in form when editing charity
   Given I am signed in as a admin
   And I am on the edit charity page for "Friendly"
   Then I should see "registered-user-1@example.com" in the charity admin email

 Scenario: No admin message displayed when charity has no admins
   Given I am signed in as a admin
   And I am on the edit charity page for "Friendly Clone"
   Then I should see the no charity admins message

 Scenario: Cannot add non-existent user as charity admin
   Given I am signed in as a admin
   And I add "non-registered-user@example.com" as an admin for "Friendly" charity
   Then I should see the cannot add non registered user "non-registered-user@example.com" as charity admin message

 Scenario: Successfully add existent user as charity admin
   Given I am signed in as a admin
   And I add "registered-user-2@example.com" as an admin for "Friendly" charity
   Then "registered-user-2@example.com" should be a charity admin for "Friendly" charity

