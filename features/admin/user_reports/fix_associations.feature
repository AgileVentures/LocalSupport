Feature: Fix Associations
  As a site owner
  So that my invitations can stop breaking
  I want to associate all invited-not-accepted users with their orgs

  Background:
    Given the following users are registered:
      | email                 | password       | admin | confirmed_at        | organization    | pending_organization |
      | admin@myorg.com       | adminpass0987  | true  | 2008-01-01 00:00:00 | My Organization |                      |
    Given the following organizations exist:
      | name     | address          | email |
      | normal   | 83 pinner road | admin@org.org  |
      | upcased | 84 pinner road | UPCASED@org.org  |
      | whitespace    | 30 pinner road | whitespace@charity.org |
    And "whitespace" has a whitespace at the end of the email address
    And the admin invited a user for "normal"
    And the admin invited a user for "upcased"
    And the admin invited a user for "whitespace"
    And associations are destroyed for:
      | name |
      | normal |
      | upcased |
      | whitespace |

  # check if the records are in the broken state
  Scenario: Broken invites as seen on the orphans page
    Given cookies are approved
    Given I am signed in as an admin
    And I visit the organisations without users page
    Then I should not see "normal"
    Then I should see "upcased"
    Then I should see "whitespace"
    # None will show on the invited users page because we don't show users
    # without associations there

  Scenario: migration
    Given I run the invite migration
    Given cookies are approved
    Given I am signed in as an admin
    And I visit the organisations without users page
    Then I should not see "normal"
    Then I should not see "upcased"
    Then I should not see "whitespace"
    And I visit the invited users page
    Then I should see "normal"
    Then I should see "upcased"
    Then I should see "whitespace"
