Feature: All Users Page
  As a Site Admin
  So that I can approve someone to be able to make edits for a particular charity
  (assuming charity admin has requested access to become charity admin and email has been sent)
  Or so that I can delete a user
  I want to be able to see all users displayed in a table, with various actions

  Background:
    Given the following organisations exist:
      | name            | address        |
      | My Organisation | 83 pinner road |
    And the following users are registered:
      | email              | password       | admin | confirmed_at        | organisation    | pending_organisation |
      | nonadmin@myorg.com | mypassword1234 | false | 2008-01-01 00:00:00 |                 |                      |
      | admin@myorg.com    | adminpass0987  | true  | 2008-01-01 00:00:00 | My Organisation |                      |
      | pending@myorg.com  | password123    | false | 2008-01-01 00:00:00 |                 | My Organisation      |
    And cookies are approved

  Scenario: As an admin approving a pending users request
    Given I am signed in as an admin
    When I approve "pending@myorg.com"
    Then I should see "You have approved pending@myorg.com."
    Then "pending@myorg.com" is a charity admin of "My Organisation"

  Scenario: As an admin deleting a user
    Given I am signed in as an admin
    When I delete "pending@myorg.com"
    Then I should see "You have deleted pending@myorg.com."
    Then user "pending@myorg.com" is deleted

  Scenario: As an admin attempting self-deletion
    Given I am signed in as an admin
    When I delete "admin@myorg.com"
    Then I should see "You may not destroy your own account!"
    Then user "admin@myorg.com" is not deleted

  Scenario Outline: As an admin I should be able to see status of all users
    Given I am signed in as an admin
    And I visit the all users page
    Then I should see "<email>"
    Examples:
      | email              |
      | nonadmin@myorg.com |
      | admin@myorg.com    |
      | pending@myorg.com  |

  Scenario: As a non-admin trying to access users index
    Given I am signed in as a non-admin
    And I visit the all users page
    Then I should be on the home page
    And I should see "You must be signed in as an admin to perform this action!"

