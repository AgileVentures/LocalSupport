Feature: Fix Associations
  As a site owner
  So that my invitations can stop breaking
  I want to associate all invited-not-accepted users with their orgs

  Background:
    Given the following users are registered:
      | email                 | password            | superadmin | confirmed_at        | organisation    | pending_organisation |
      | superadmin@myorg.com  | superadminpass0987  | true       | 2008-01-01 00:00:00 | My Organisation |                      |
    Given the following organisations exist:
      | name          | description      | address          | postcode | email                  |
      | normal        | Awesome people   | 83 pinner road   | HA1 4HZ  | superadmin@org.org     |
      | upcased       | Awesome people   | 84 pinner road   | HA1 4HZ  | UPCASED@org.org        |
      | whitespace    | Awesome people   | 30 pinner road   | HA1 4HZ  | whitespace@charity.org |
    And the invitation instructions mail template exists
    And "whitespace" has a whitespace at the end of the email address
    And the superadmin invited a user for "normal"
    And the superadmin invited a user for "upcased"
    And the superadmin invited a user for "whitespace"
    And associations are destroyed for:
      | name |
      | normal |
      | upcased |
      | whitespace |

  # check if the records are in the broken state
  @vcr
  Scenario: Broken invites as seen on the orphans page
    Given cookies are approved
    Given I am signed in as a superadmin
    And I visit the invite users to become admin of organisations page
    Then I should not see "normal"
    Then I should see "upcased"
    Then I should see "whitespace"
    # None will show on the invited users page because we don't show users
    # without associations there

  Scenario: migration
    Given I run the fix invitations rake task
    Given cookies are approved
    Given I am signed in as a superadmin
    And I visit the invite users to become admin of organisations page
    Then I should not see "normal"
    Then I should not see "upcased"
    Then I should not see "whitespace"
    And I visit the invited users page
    Then I should see "normal"
    Then I should see "upcased"
    Then I should see "whitespace"
