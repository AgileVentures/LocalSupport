Feature: As a member of the public
  So that I can see where organisations with volunteer opportunities are located
  I would like to see a map of volunteer opportunities
  Tracker story ID: https://www.pivotaltracker.com/story/show/66059862

  Background: organisations with volunteer opportunities have been added to database

    Given the following organisations exist:
      | name                      | description          | address        | postcode | website       |
      | Cats Are Us               | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association | Care for the elderly | 64 pinner road | HA1 4HA  | http://b.com/ |
    Given the following volunteer opportunities exist:
      | title              | description                     | organisation              |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us               |
      | Office Support     | Help with printing and copying. | Indian Elders Association |

  Scenario: See a map of current volunteer opportunities
    Given I visit the volunteer opportunities page
    And cookies are approved
    And I should see "Indian Elders Association" and "Cats Are Us" in the map

  Scenario Outline: Volunteer opportunites are listed in map popups
    Given I visit the volunteer opportunities page
    And cookies are approved
    And the map should show the opportunity <name>
    Examples:
      | name               |
      | Litter Box Scooper |
      | Office Support     |
