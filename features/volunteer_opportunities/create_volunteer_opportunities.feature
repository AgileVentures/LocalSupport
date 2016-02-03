Feature: Org superadmin creating a volunteer work opportunity
  As an organisation superadmin
  So that I can recruit volunteers
  I would like to be able to add a volunteering opportunity to the system
  https://www.pivotaltracker.com/story/show/66059456

  Background:
    Given the following organisations exist:
      | name     | description             | address        | postcode | telephone | website                     | email                      |
      | Friendly | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.example.org | superadmin@friendly.example.org |
      | Shy      | Software design         | 34 pinner road | HA1 4HZ  | 020800001 | http://shy.example.org      | superadmin@shy.example.org      |

    And the following users are registered:
      | email                      | password | organisation | confirmed_at        | superadmin |
      | friend@harrowcn.org.uk     | pppppppp |              | 2007-01-01 10:00:00 | false |
      | superadmin@friendly.example.org | pppppppp | Friendly     | 2007-01-01 10:00:00 | false |
      | superadmin@shy.example.org      | pppppppp | Shy          | 2007-01-01 10:00:00 | false |
      | superadmin@harrowcn.org.uk      | pppppppp | Shy          | 2007-01-01 10:00:00 | true  |
    And that the volunteer_ops_create flag is enabled
    And cookies are approved

  @vcr
  Scenario: Org-superadmins can create a volunteer opportunity
    Given I am signed in as a charity worker related to "Friendly"
    And I submit a volunteer op "Hard Work", "For no pay" on the "Friendly" page
    Then I should be on the show page for the volunteer_op titled "Hard Work"
    And I should see "Hard Work", "For no pay" and "Organisation: Friendly"

  Scenario: Org-superadmins can create a volunteer opportunity but get warning with invalid data
    Given I am signed in as a charity worker related to "Friendly"
    And I submit a volunteer op "", "" on the "Friendly" page
    And I should see "Title can't be blank" and "Description can't be blank"

  Scenario: Site Super Admin users can create Volunteer Opportunities
    Given I am signed in as a superadmin
    And I submit a volunteer op "Hard Work", "For no pay" on the "Friendly" page
    Then I should be on the show page for the volunteer_op titled "Hard Work"
    And I should see "Hard Work", "For no pay" and "Organisation: Friendly"

  Scenario: Signed In Users cannot create volunteer opportunities
    Given I am signed in as a charity worker related to "Shy"
    And I visit the show page for the organisation named "Friendly"
    Then I should not see a link with text "Create a Volunteer Opportunity"

  Scenario: Signed In Users cannot create volunteer opportunities on the sly
    Given I am signed in as a charity worker related to "Friendly"
    And I visit the new volunteer op page for "Shy"
    Then I should see "You must be signed in as an organisation owner or site superadmin to perform this action!"

  Scenario: Not Signed In Users cannot create volunteer opportunities
    Given I visit the show page for the organisation named "Friendly"
    Then I should not see a link with text "Create a Volunteer Opportunity"

  Scenario: Not Signed In Users cannot create volunteer opportunities on the sly
    And I visit the new volunteer op page for "Shy"
    Then I should see "You must be signed in as an organisation owner or site superadmin to perform this action!"

  # TESTS TO CHECK WHETHER API ENDPOINT IS SECURE ARE IN REQUEST SPECS

  # FEATURE FLAG RELATED SCENARIOS

  Scenario: Org-superadmins can see a Volunteer Opportunity button when feature is enabled
    And I am signed in as a charity worker related to "Shy"
    And I visit the show page for the organisation named "Shy"
    Then I should see a link with text "Create a Volunteer Opportunity"

  Scenario: Org-superadmins cannot see a Volunteer Opportunity button when feature is disabled
    Given that the volunteer_ops_create flag is disabled
    And I am signed in as a charity worker related to "Shy"
    And I visit the show page for the organisation named "Shy"
    Then I should not see a link with text "Create a Volunteer Opportunity"
