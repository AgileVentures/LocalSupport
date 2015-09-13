Feature: Orphans UI
  As the site owner
  So that I look up orphan orgs and email prospective users
  I want a UI that shows me orphan orgs and allows me to generate user accounts for them

  Background:
    Given the following organisations exist:
      | name               | address        | email             | postcode |
      | The Organisation   | 83 pinner road | no_owner@org.org  | HA1 4HZ  |
      | The Same Email Org | 84 pinner road | no_owner@org.org  | HA1 4HZ  |
      | Crazy Email Org    | 30 pinner road | sahjkgdsfsajnfds  | HA1 4HZ  |
      | My Organisation    | 30 pinner road | superadmin@myorg.com   | HA1 4HZ  |
      | Yet Another Org    | 30 pinner road | superadmin@another.org | HA1 4HZ  |
    And the following users are registered:
      | email                 | password       | superadmin | confirmed_at        | organisation    | pending_organisation |
      | nonsuperadmin@myorg.com    | mypassword1234 | false | 2008-01-01 00:00:00 |                 |                      |
      | superadmin@myorg.com       | superadminpass0987  | true  | 2008-01-01 00:00:00 | My Organisation |                      |
      | pending@myorg.com     | password123    | false | 2008-01-01 00:00:00 |                 | My Organisation      |
      | invited-superadmin@org.org | password123    | false | 2008-01-01 00:00:00 |                 |                      |
    And the superadmin invited a user for "Yet Another Org"

  @javascript
  Scenario: Super Admin can invite users but only for unique emails
    Given cookies are approved
    Given I am signed in as a superadmin
    And I visit the organisations without users page
    And I check the box for "The Organisation"
    And I check the box for "The Same Email Org"
    When I click id "invite_users"
    Then I should see "Invited!" in the response field for "The Organisation"
    Then I should see "Error: Email has already been taken" in the response field for "The Same Email Org"

  Scenario: Already invited organisations don't appear
    Given cookies are approved
    And I am signed in as a superadmin
    And I visit the organisations without users page
    Then I should not see "Yet Another Org"

  @javascript
  Scenario: Super Admin should be notified when email is invalid
    Given cookies are approved
    Given I am signed in as a superadmin
    And I visit the organisations without users page
    And I check the box for "Crazy Email Org"
    When I click id "invite_users"
    Then I should see "Error: Email is invalid" in the response field for "Crazy Email Org"

  Scenario: As a non-superadmin trying to access orphans index
    Given cookies are approved
    Given I am signed in as a non-superadmin
    And I visit the organisations without users page
    Then I should be on the home page
    And I should see "You must be signed in as a superadmin to perform this action!"

  #These next two scenarios apply to layouts/invitation_table
  @javascript
  Scenario: Table columns should be sortable
    Given cookies are approved
    Given I am signed in as a superadmin
    And I visit the organisations without users page
    And I click tableheader "Name"
    Then I should see "Crazy Email Org" before "The Organisation"
    When I click tableheader "Name"
    Then I should see "The Organisation" before "Crazy Email Org"

  @javascript
  Scenario: Select All button toggles all checkboxes
    Given cookies are approved
    Given I am signed in as a superadmin
    And I visit the organisations without users page
    And I press "Select All"
    Then all the checkboxes should be checked
    When I press "Select All"
    Then all the checkboxes should be unchecked

  #The next two scenarios check the flow of the user accepting the invitation
  Scenario: Invited user clicking through on email with cookies policy clicked
    Given I click on the invitation link in the email to "superadmin@another.org"
    And I accepted the cookie policy from the "invitation" page
    And I set my password
    Then I should be on the show page for the organisation named "Yet Another Org"

  Scenario: Invited user clicking through on email ignoring cookies policy
    Given I click on the invitation link in the email to "superadmin@another.org"
    And I set my password
    Then I should be on the show page for the organisation named "Yet Another Org"

  Scenario: Invited user email is out of date
    Given cookies are approved
    And I am signed in as a superadmin
    And I visit the organisations without users page
    Then I should not see "Yet Another Org"
    When I edit the charity email of "Yet Another Org" to be "other_email@charity.com"
    And I visit the organisations without users page
    Then I should see "Yet Another Org"
