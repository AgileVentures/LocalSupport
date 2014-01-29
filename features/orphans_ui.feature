Feature: Orphans UI
  As the site owner
  So that I look up orphan orgs and email prospective users
  I want a UI that shows me orphan orgs and allows me to generate user accounts for them

Background:
  Given the following organizations exist:
    | name               | address        | email            |
    | The Organization   | 83 pinner road | no_owner@org.org |
    | The Same Email Org | 84 pinner road | no_owner@org.org |
    | Crazy Email Org    | 30 pinner road | sahjkgdsfsajnfds |
    | My Organization    | 30 pinner road | admin@myorg.com  |
  And the following users are registered:
    | email              | password       | admin | confirmed_at        | organization    | pending_organization |
    | nonadmin@myorg.com | mypassword1234 | false | 2008-01-01 00:00:00 |                 |                      |
    | admin@myorg.com    | adminpass0987  | true  | 2008-01-01 00:00:00 | My Organization |                      |
    | pending@myorg.com  | password123    | false | 2008-01-01 00:00:00 |                 | My Organization      |
  And cookies are approve

  @javascript
  Scenario: Admin can generate link but only for unique email
    Given I visit "/orphans"
    When I click Generate User button for "The Organization"
    Then a token should be in the response field for "The Organization"
    When I click Generate User button for "The Same Email Org"
    Then I should see "Email has already been taken" in the response field for "The Same Email Org"

  @javascript
  Scenario: Admin should be notified when email is invalid
    Given I visit "/orphans"
    When I click Generate User button for "Crazy Email Org"
    Then I should see "Email is invalid" in the response field for "Crazy Email Org"

  Scenario: As a non-admin trying to access orphans index
    Given I am signed in as a non-admin
    And I visit "/orphans"
    Then I should be on the home page
    And I should see "You must be signed in as an admin to perform this action!"

