Feature: Web page owned by each charity
  As a charity worker
  So that I can increase my charity's visibility
  I want to have a web presence
  Tracker story ID: https://www.pivotaltracker.com/story/show/45405153

  Background: organisations have been added to database
    Given the following organisations exist:
      | name       | description             | address        | postcode | telephone | website             | email             |
      | Friendly   | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.org | superadmin@friendly.xx |
      | Unfriendly | Bunch of jerks          | 30 pinner road |          | 020800010 |                     |                   |
    Given the following users are registered:
      | email                         | password | organisation | confirmed_at         |
      | registered_user-1@example.com | pppppppp | Friendly     | 2007-01-01  10:00:00 |
      | registered_user-2@example.com | pppppppp |              | 2007-01-01  10:00:00 |
    And that the search_input_bar_on_org_pages flag is enabled
    And I visit the show page for the organisation named "Friendly"

    Given the following categories exist:
      | name              | charity_commission_id |
      | Animal Welfare    | 101                   |
      | Health            | 102                   |
      | Education         | 103                   |
      | Voluntary         | 201                   |
      | Finance           | 301                   |
      | Advocacy          | 303                   |
     Given the following categories_organisations exist:

      | category        | organisation |
      | Health          | Friendly     |
      | Education       | Friendly     |
      | Voluntary       | Friendly     |
      | Finance         | Friendly     |
      | Advocacy        | Unfriendly   |

    And I visit the show page for the organisation named "Friendly"

  @vcr
  Scenario: Search for organisations on an organization individual page
    Given I select the "Advocacy" category from How They Help
    And I press "Submit"
    Then I should see "Unfriendly"
    And I should not see "Friendly"

  Scenario: be able to view link to charity site on individual charity page
    Then I should see the external website link for "Friendly" charity

  Scenario: display charity title in a visible way
    Then I should see "Friendly" < tagged > with "h2"

  Scenario: show organisation e-mail as link
    Then I should see a mail-link to "superadmin@friendly.xx"

  Scenario: show categories of charity by type
    Then I should see "Health" within "what_they_do"
    And I should see "Education" within "what_they_do"
    And I should see "Voluntary" within "who_they_help"
    And I should see "Finance" within "how_they_help"
    And I should not see "Animal Welfare" within "what_they_do"
    And I visit the show page for the organisation named "Unfriendly"
    Then I should not see "Health" within "what_they_do"
    And I should not see "Education" within "what_they_do"
    And I should not see "Animal Welfare" within "what_they_do"

  Scenario: categories link to search results of orgs with these categories
    Given I click "Health"
    Then I should be on the organisations search page
    And I should see "Friendly"

  Scenario Outline: show labels if field is present
    Then I should see "<label>"
  Examples:
    | label    |
    | Postcode |
    | Email    |
    | Website  |

  Scenario Outline: hide labels if field is empty
    Given I visit the show page for the organisation named "Unfriendly"
    Then I should not see "<label>"
  Examples:
    | label    |
    | Postcode |
    | Email    |
    | Website  |

