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
    And the following self care categories exist:
      | name              | 
      | Autism            |
      | Advocacy          |

  @vcr
  Scenario: Page header not displayed
    Given I visit the services page with hide_navbar set to true
    And cookies are approved
    Then I should not see the navbar on the page

  Scenario: Page header is displayed
    Given I visit the services page with hide_navbar not set to true
    And cookies are approved
    Then I should see the navbar on the page
