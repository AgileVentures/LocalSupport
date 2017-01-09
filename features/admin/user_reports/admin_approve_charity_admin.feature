Feature: All Users Page
  As a Site Super Admin
  So that I can approve someone to be able to make edits for a particular charity
  (assuming charity superadmin has requested access to become charity superadmin and email has been sent)
  Or so that I can delete a user
  I want to be able to see all users displayed in a table, with various actions

  Background:
    Given the following organisations exist:
      | name            | description    | address        | postcode |
      | My Organisation | Awesome people | 83 pinner road | HA1 4HZ  |
    And the following users are registered:
      | email                   | password            | superadmin | confirmed_at        | organisation    | pending_organisation |
      | nonsuperadmin@myorg.com | mypassword1234      | false      | 2008-01-01 00:00:00 |                 |                      |
      | superadmin@myorg.com    | superadminpass0987  | true       | 2008-01-01 00:00:00 | My Organisation |                      |
      | pending@myorg.com       | password123         | false      | 2008-01-01 00:00:00 |                 | My Organisation      |
    And cookies are approved

  @vcr
  Scenario: As a superadmin approving a pending users request
    Given I am signed in as a superadmin
    When I approve "pending@myorg.com"
    Then I should see "You have approved pending@myorg.com."
    Then "pending@myorg.com" is an organisation admin of "My Organisation"

  Scenario: As a superadmin deleting a user
    Given I am signed in as a superadmin
    When I delete "pending@myorg.com"
    Then I should see "You have deleted pending@myorg.com."
    Then user "pending@myorg.com" is deleted

  Scenario: As a superadmin declining a timo request but not deleting the user
    Given I am signed in as a superadmin
    When I decline "pending@myorg.com"
    Then I should see "You have declined pending@myorg.com's request for admin status for My Organisation."
    Then "pending@myorg.com" is not an organisation admin of "My Organisation"
    And "pending@myorg.com"'s request for "My Organisation" should not be persisted

  Scenario: As a superadmin about to recover a deleted user
    Given I am signed in as a superadmin
    And I visit the home page
    And I click on the deleted users link
    Then I should be on the deleted users page

  Scenario: As a superadmin recovering a deleted user
    Given I am signed in as a superadmin
    And I delete "pending@myorg.com"
    Then the user with email "pending@myorg.com" should be displayed on the all deleted users page
    And I restore the user with the email "pending@myorg.com"
    Then user "pending@myorg.com" is not deleted
    And I should see "You have restored pending@myorg.com"
    And the user with email "pending@myorg.com" should not be displayed on the all deleted users page

  Scenario: as a non-superadmin attempting to see deleted users
    Given I am signed in as an non-superadmin
    And I visit the deleted users page
    Then I should be on the home page
    And I should see "You must be signed in as a superadmin to perform this action!"

  Scenario: As a superadmin attempting self-deletion
    Given I am signed in as a superadmin
    When I delete "superadmin@myorg.com"
    Then I should see "You may not destroy your own account!"
    Then user "superadmin@myorg.com" is not deleted

  Scenario Outline: As a superadmin I should be able to see status of all users
    Given I am signed in as a superadmin
    And I visit the registered users page
    Then I should see "<email>"
    Examples:
      | email              |
      | nonsuperadmin@myorg.com |
      | superadmin@myorg.com    |
      | pending@myorg.com  |

  Scenario: As a non-superadmin trying to access users index
    Given I am signed in as a non-superadmin
    And I visit the registered users page
    Then I should be on the home page
    And I should see "You must be signed in as a superadmin to perform this action!"
