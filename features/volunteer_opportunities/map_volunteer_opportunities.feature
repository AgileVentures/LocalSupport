Feature: As a member of the public
  So that I can see where organisations with volunteer opportunities are located
  I would like to see a map of volunteer opportunities
  Tracker story ID: https://www.pivotaltracker.com/story/show/66059862

  Background: organisations with volunteer opportunities have been added to database

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

  @javascript @vcr @billy
  Scenario: See a map of current volunteer opportunities
    Given I visit the volunteer opportunities page
    And cookies are approved
    And I should see the following vol_op markers in the map:
    | Indian Elders Association| Cats Are Us |

  @javascript @billy
  Scenario Outline: Volunteer opportunites are listed in map popups
    Given I visit the volunteer opportunities page
    And cookies are approved
    And the map should show the opportunity titled <title>
    Examples:
      | title              |
      | Litter Box Scooper |
      | Office Support     |

  @javascript @billy
  Scenario: See map when editing my volunteer opportunity
    Given I am signed in as a charity worker related to "Cats Are Us"
    And I visit the edit page for the volunteer_op titled "Litter Box Scooper"
    Then the map should show the opportunity titled Litter Box Scooper
