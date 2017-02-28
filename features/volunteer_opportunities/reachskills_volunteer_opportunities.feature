@vcr @javascript @billy
Feature: Reachskills volunteer opportunities
  As a member of the public
  So that I can see where organisations with volunteer opportunities are located
  I would like to see a map of reachskills volunteer opportunities

  Background:
    Given that the doit_volunteer_opportunities flag is enabled
    Given that the reachskills_volunteer_opportunities flag is enabled
    And I run the import reachskills service
    And cookies are approved

  Scenario: See a map of current reachskills volunteer opportunities
    And I visit the volunteer opportunities page
    And I should see 8 markers in the map

  Scenario: See a map of current reachskills and harrow volunteer opportunities
    Given the following organisations exist:
      | name                      | description          | address        | postcode | website       |
      | Cats Are Us               | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |
    Given the following users are registered:
      | email                         | password | organisation | confirmed_at         |
      | registered_user-1@example.com | pppppppp | Cats Are Us  | 2007-01-01  10:00:00 |
    Given the following volunteer opportunities exist:
      | title              | description                     | organisation              |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us               |
      | Office Support     | Help with printing and copying. | Indian Elders Association |
    And I visit the volunteer opportunities page
    And I should see 10 markers in the map

  Scenario: See a list of current reachskills volunteer opportunities with a link to organisation page
    Given I visit the volunteer opportunities page
    And wait for 3 seconds
    Then the index should contain:
      | Fundraising Volunteer | The volunteer will be required to work with the fundraising consultant research trusts and corporate grant making foundations appropriate to the ... | Chalkhill Community Centre |
    Then I should see a link to "Chalkhill Community Centre" page "https://reachskills.org.uk/org/chalkhill-community-centre"

  Scenario: Reachskills volunteer opportunites are listed in map popups
    Given I visit the volunteer opportunities page
    And wait for 3 seconds
    And the map should show the opportunity titled Literacy Trainer (The Princess Alexandra Home)

  Scenario: Reachskills volunteer opportunities are opened in a new page
    Given I visit the volunteer opportunities page
    And wait for 3 seconds
    Then I should open "Fundraising Volunteer" in a new window
