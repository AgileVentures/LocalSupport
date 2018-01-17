Feature: View Breadcrumbs
  As a user of the community
  So that I can easily backtrace my steps in the application
  I would like to have breadcrumbs properly displayed

  Background: organisations with volunteer opportunities have been added to database

    Given the following organisations exist:
      | name                      | description          | address        | postcode | website       |
      | Cats Are Us               | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |
    Given the following volunteer opportunities exist:
      | title              | description                     | organisation              |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us               |
      | Office Support     | Help with printing and copying. | Indian Elders Association |

  Scenario: User visits volunteer opportunities home page
    Given I visit the volunteer opportunities page
    Then I should see a link to "home" page "/"
    And I should see "home » Volunteers"

  Scenario: User visits volunteer opportunity from volunteer opportunities page
    Given I visit the volunteer opportunities page
    Given I visit the show page for the volunteer_op titled "Office Support"
    Then I should see a link to "home" page "/"
    And I should see a link to "Volunteers" page "/"
    And I should see a link to "Indian Elders Association" page "/organisations/indian-elders-association"
    And I should see "home » Volunteers » Indian Elders Association » Office Support"
