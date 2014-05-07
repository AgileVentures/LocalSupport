Feature: Invited Users Page
  As the site owner
  So that I manage the invitation process
  I want a page that shows me who I have already invited

  Background:
    Given the following organizations exist:
      | name                 | address        | email            |
      | Invited Organization | 30 pinner road | invited@user.org |
    And the following users are registered:
      | email            | password       | admin | confirmed_at        | organization    | pending_organization |
      | admin@myorg.com  | adminpass0987  | true  | 2008-01-01 00:00:00 | My Organization |                      |
      | regular@user.org | mypassword1234 | false | 2008-01-01 00:00:00 |                 |                      |
    And the admin invited a user for "Invited Organization"

  Scenario: Page shows only invited users
    Given cookies are approved
    And I am signed in as an admin
    And I visit the invited users page
    Then I should see "invited@user.org"
    And I should not see "regular@user.org"

  @javascript
  Scenario: Invitations can be resent
    Given cookies are approved
    Given I am signed in as an admin
    And I visit the invited users page
    And I check the box for "Invited Organization"
    When I click id "invite_users"
    Then I should see "Invited!" in the response field for "Invited Organization"

