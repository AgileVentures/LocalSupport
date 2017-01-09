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
    And the invitation instructions mail template exists
    And cookies are approved

 @vcr
 Scenario: Existing charity superadmin appears in form when editing charity
   Given I am signed in as a superadmin
   And I visit the edit page for the organisation named "Friendly"
   Then I should see "registered-user-1@example.com" in the charity superadmin email

 Scenario: No superadmin message displayed when charity has no superadmins
   Given I am signed in as a superadmin
   And I visit the edit page for the organisation named "Friendly Clone"
   Then I should see the no charity superadmins message

  Scenario: Adding non-existent user as charity superadmin invites said user
   Given I am signed in as a superadmin
   And I add "non-registered-user@example.com" as a superadmin for "Friendly" charity
   Then "non-registered-user@example.com" should be a charity superadmin for "Friendly" charity
   And I click on the invitation link in the email to "non-registered-user@example.com"
   And I set my password
   Then I should be on the show page for the organisation named "Friendly"
   And I should see a link or button "non-registered-user@example.com"

  Scenario: Adding non-existent user as charity superadmin invites said user
   Given I am signed in as a superadmin
   And I add "blah" as a superadmin for "Friendly" charity

 Scenario: Successfully add existent user as charity superadmin
   Given I am signed in as a superadmin
   And I add "registered-user-2@example.com" as a superadmin for "Friendly" charity
   Then "registered-user-2@example.com" should be a charity superadmin for "Friendly" charity
   Then an email should be sent to "registered-user-2@example.com" as notice of becoming org admin of "Friendly"
