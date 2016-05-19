Feature: Local Resident seeking Support
  As a local resident
  So that I can get support for a specific malady
  I want to find contact details for a local service specific to my need
  Tracker story ID: https://www.pivotaltracker.com/story/show/43946779

  Background: organisations have been added to database

    Given the following organisations exist:
      | name                           | description                  | address        | postcode | website       |
      | Harrow Bereavement Counselling | Counselling for the bereaved | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association      | Care for the elderly         | 64 pinner road | HA1 4HZ  | http://b.com/ |
      | Age UK                         | Care for the Elderly         | 84 pinner road | HA1 4HZ  | http://c.com/ |

# particularly want to provide visibility to organisations with no existing web presence
  @vcr
  Scenario: Find help with care for elderly
    Given I visit the home page
    When I search for "elderly"
    Then the index should contain:
      | Indian Elders Association | Care for the elderly |
      | Age UK                    | Care for the Elderly |
    And the index should not contain:
      | Harrow Bereavement Counselling | Counselling for the bereaved |
    And the search box should contain "elderly"

# starting within main site
  Scenario: Find a bereavement counsellor
    Given I visit the home page
    When I search for "Bereavement Counselling"
    And the index should contain:
      | Harrow Bereavement Counselling | Counselling for the bereaved |
    Then the index should not contain:
      | Indian Elders Association | Care for the elderly |
      | Age UK                    | Care for the Elderly |
    Then I should not see the no results message

  Scenario: Find friendly no search results message
    Given I visit the home page
    When I search for "non-existent results"
    Then I should see the no results message
    Given I visit the home page
    Then I should not see the no results message

  Scenario: See a list of current organisations
    Given I visit the home page
    And cookies are approved
    Then the index should contain:
      | Harrow Bereavement Counselling | Counselling for the bereaved |
      | Indian Elders Association      | Care for the elderly           |
      | Age UK                         | Care for the Elderly           |
