Feature: List Services
  As a member of a health care team
  So that I can find out what services are available in my Primary Care Network area
  I would like to see a list of services organised geographically
  
  Background: organisations with services have been added to database

  Given the following organisations exist:
    | name                      | description          | address        | postcode | website       |
    | Cats Are Us               | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
    | Indian Elders Association | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |
  And the following services exist:
    | name               | description                     | organisation              |
    | Litter Box Scooper | Help with feline sanitation     | Cats Are Us               |
    | Office Support     | Help with printing and copying. | Indian Elders Association |

  @vcr
  Scenario: See a list of current services
    Given I visit the services page
    And cookies are approved
    Then the index should contain:
    | Litter Box Scooper              | Help with feline sanitation        | Cats Are Us               |
    | Office Support                  | Help with printing and copying.    | Indian Elders Association |
