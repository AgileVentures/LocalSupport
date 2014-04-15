Feature: Org admin creating a volunteer work opportunity
  As an organisation admin
  So that I can recruit volunteers
  I would like to be able to add a volunteering opportunity to the system

  Background:
    Given the following organizations exist:
      | name     | description             | address        | postcode | telephone | website             | email              |
      | Friendly | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.org | admin@friendly.org |
    And the following users are registered:
      | email              | password | organization | confirmed_at        |
      | admin@friendly.org | pppppppp | Friendly     | 2007-01-01 10:00:00 |
    And cookies are approved

  Scenario: Org-owners can see a Create Volunteer Opportunity button on their organization show page
    Given I am signed in as a charity worker related to "Friendly"
    And I am on the charity page for "Friendly"
    And I click "Create a Volunteer Opportunity"
    Then I should be on the new volunteer opportunity page for organization "Friendly"

  Scenario: Org-owner creating a volunteer opportunity
    Given I am signed in as a charity worker related to "Friendly"
    And I visit the new volunteer opportunity page for organization "Friendly"
    And I should see "Create a new Volunteer Opportunity"
    And I submit an opportunity with title "Hard Work" and description "For no pay"
    Then I should be on the show volunteer opportunity page for organization "Friendly"
    And I should see "Hard Work"
    And I should see "For no pay"

  Scenario: Only org-owners can create volunteer opportunities
    # Tested that the API is restricted in the request spec
    Given I am on the charity page for "Friendly"
    Then I should not see a link with text "Create Volunteer Opportunity"
