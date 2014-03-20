Feature: Orphans UI
  As the site owner
  So that I look up orphan orgs and email prospective users
  I want a UI that shows me orphan orgs and allows me to generate user accounts for them

  Background:
    Given the following organizations exist:
      | name               | address        | email             |
      | The Organization   | 83 pinner road | no_owner@org.org  |
      | The Same Email Org | 84 pinner road | no_owner@org.org  |
      | Crazy Email Org    | 30 pinner road | sahjkgdsfsajnfds  |
      | My Organization    | 30 pinner road | admin@myorg.com   |
      | Yet Another Org    | 30 pinner road | admin@another.org |
    And the following users are registered:
      | email                 | password       | admin | confirmed_at        | organization    | pending_organization |
      | nonadmin@myorg.com    | mypassword1234 | false | 2008-01-01 00:00:00 |                 |                      |
      | admin@myorg.com       | adminpass0987  | true  | 2008-01-01 00:00:00 | My Organization |                      |
      | pending@myorg.com     | password123    | false | 2008-01-01 00:00:00 |                 | My Organization      |
      | invited-admin@org.org | password123    | false | 2008-01-01 00:00:00 |                 |                      |
    And the email queue is clear
    And the admin invited a user for "Yet Another Org"
    And an email with subject line "Invitation to Harrow Community Network" should have been sent

  Scenario: Email attributes
    Then the queue should have an email with subject line "Invitation to Harrow Community Network"
    And the queue should have an email with cc "technical@harrowcn.org.uk"

  Scenario: Invited user clicking through on email with cookies policy clicked
    Given I click on the invitation link in the email to "admin@another.org"
    And I accepted the cookie policy from the "invitation" page
    And I set my password
    Then I should be on the charity page for "Yet Another Org"

  Scenario: Invited user clicking through on email ignoring cookies policy
    Given I click on the invitation link in the email to "admin@another.org"
    And I set my password
    Then I should be on the charity page for "Yet Another Org"

