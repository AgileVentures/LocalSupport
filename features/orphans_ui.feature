Feature: Orphans UI
  As the site owner
  So that I look up orphan orgs and email prospective users
  I want a UI that shows me orphan orgs and allows me to generate user accounts for them

Background:
  Given the following organizations exist:
    | name             | address        | email            |
    | The Organization | 83 pinner road | no_owner@org.org |
    | The Collective   | 84 pinner road | no_owner@org.org |
    | The Loony Bin   | 30 pinner road | sahjkgdsfsajnfds |
  And cookies are approved
  And I visit "/orphans"


  @javascript
  Scenario: Generate User button
    When I click Generate User button for "The Organization"
    Then a token should be in the response field for "The Organization"
    When I click Generate User button for "The Collective"
    Then I should see "Email has already been taken" in the response field for "The Collective"
    When I click Generate User button for "The Loony Bin"
    Then I should see "Email is invalid" in the response field for "The Loony Bin"
