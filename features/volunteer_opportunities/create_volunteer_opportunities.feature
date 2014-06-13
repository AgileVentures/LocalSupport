Feature: Org admin creating a volunteer work opportunity
  As an organisation admin
  So that I can recruit volunteers
  I would like to be able to add a volunteering opportunity to the system
  https://www.pivotaltracker.com/story/show/66059456

  Background:
    Given the following organizations exist:
      | name     | description             | address        | postcode | telephone | website                     | email                      |
      | Friendly | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.example.org | admin@friendly.example.org |
      | Shy      | Software design         | 34 pinner road | HA1 1AA  | 020800001 | http://shy.example.org      | admin@shy.example.org      |

    And the following users are registered:
      | email                      | password | organization | confirmed_at        | admin |
      | admin@friendly.example.org | pppppppp | Friendly     | 2007-01-01 10:00:00 | false |
      | admin@shy.example.org      | pppppppp | Shy          | 2007-01-01 10:00:00 | false |
      | admin@harrowcn.org.uk      | pppppppp | Shy          | 2007-01-01 10:00:00 | true  |
    And that the volunteer_ops_create flag is enabled
    And cookies are approved

  Scenario: Org-owner creating a volunteer opportunity
    Given I am signed in as a charity worker related to "Friendly"
    And I visit the new volunteer opportunity page for organization "Friendly"
    And I should see "Create a new Volunteer Opportunity"
    And I submit an opportunity with title "Hard Work" and description "For no pay"
    Then I should be on the show volunteer opportunity page for organization "Friendly"
    And I should see "Hard Work"
    And I should see "For no pay"
    And I should see "Organisation: Friendly"

  Scenario: Only org-owners can create volunteer opportunities
    # Tested that the API is restricted in the request spec
    Given I am on the charity page for "Friendly"
    Then I should not see a link with text "Create a Volunteer Opportunity"

  Scenario: Signed in users who don't own the org cannot create volunteer opportunities
    Given I am signed in as a charity worker related to "Shy"
    And I am on the charity page for "Friendly"
    Then I should not see a link with text "Create a Volunteer Opportunity"

  Scenario: Admin users who don't own the org cannot create volunteer opportunities
    Given I am signed in as a admin
    And I am on the charity page for "Friendly"
    Then I should not see a link with text "Create a Volunteer Opportunity"

  Scenario: Org-owners can see a Create Volunteer Opportunity button on their organization show page when feature is enabled
    And I am signed in as a charity worker related to "Shy"
    And I am on the charity page for "Shy"
    Then I should see a link with text "Create a Volunteer Opportunity"

  Scenario: Org-owners cannot see a Create Volunteer Opportunity button on their organization show page when feature is disabled
    Given that the volunteer_ops_create flag is disabled
    And I am signed in as a charity worker related to "Shy"
    And I am on the charity page for "Shy"
    Then I should not see a link with text "Create a Volunteer Opportunity"

