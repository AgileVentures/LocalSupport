Feature: Invited Users Page
  As the site owner
  So that I manage the invitation process
  I want a page that shows me who I have already invited

  Background:
    Given the following organisations exist:
      | name                 | description    | address        | postcode | email            |
      | Invited Organisation | Awesome people | 30 pinner road | HA1 4HZ  | invited@user.org |
    And the following users are registered:
      | email            | password       | superadmin | confirmed_at        | organisation    | pending_organisation |
      | superadmin@myorg.com  | superadminpass0987  | true  | 2008-01-01 00:00:00 | My Organisation |                      |
      | regular@user.org | mypassword1234 | false | 2008-01-01 00:00:00 |                 |                      |
    And the invitation instructions mail template exists
    And the superadmin invited a user for "Invited Organisation"
    And cookies are approved
    And I am signed in as a superadmin
    And I visit the invited users page

  @vcr
  Scenario: Page shows only invited users
    Then I should see "invited@user.org"
    And I should not see "regular@user.org"

  Scenario: Super Admin can see the preview email
    Then I should see the preview email

  @javascript @billy
  Scenario: Invitations can be resent
    Given I check the box for "Invited Organisation"
    When I click id "invite_users"
    Then I should see "Invited!" in the response field for "Invited Organisation"
