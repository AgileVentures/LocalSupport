Feature: Manage charity superadmins
  As a site superadmin
  So that users can keep their charity information up to date
  I want to manage the superadministrators associated with charities

Background: organisations have been added to database
    Given the following organisations exist:
      | name           | description             | address        | postcode | telephone |
      | Friendly       | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 |
      | Friendly Clone | Quite Friendly!         | 30 pinner road | HA1 4HZ  | 020800010 |
    And the following users are registered:
      | email             | password | superadmin | confirmed_at |  organisation |
      | registered-user-1@example.com | pppppppp | true  | 2007-01-01  10:00:00 |  Friendly |
      | registered-user-2@example.com | pppppppp | false | 2007-01-01  10:00:00 |           |
    And cookies are approved

 @vcr
 Scenario: Existing charity superadmin appears in form when editing charity
   Given I am signed in as a superadmin
   And I visit the edit page for the organisation named "Friendly"
   Then I should see "registered-user-1@example.com" in the charity superadmin email

 @vcr
 Scenario: No superadmin message displayed when charity has no superadmins
   Given I am signed in as a superadmin
   And I visit the edit page for the organisation named "Friendly Clone"
   Then I should see the no charity superadmins message

 @vcr  
 Scenario: Cannot add non-existent user as charity superadmin
   Given I am signed in as a superadmin
   And I add "non-registered-user@example.com" as a superadmin for "Friendly" charity
   Then I should not see "non-registered-user-1@example.com" in the charity superadmin email
   And I should see "The user email you entered,'non-registered-user@example.com', does not exist in the system" in the flash error

 @vcr
 Scenario: Successfully add existent user as charity superadmin
   Given I am signed in as a superadmin
   And I add "registered-user-2@example.com" as a superadmin for "Friendly" charity
   Then "registered-user-2@example.com" should be a charity superadmin for "Friendly" charity
