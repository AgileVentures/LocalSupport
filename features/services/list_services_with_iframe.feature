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
    And I visit the services iframe page
    And cookies are approved

  @vcr
  Scenario: See a list of current services
    Then the index should contain:
    | Litter Box Scooper              | Help with feline sanitation        | 
    | Office Support                  | Help with printing and copying.    | 

  Scenario: Not see header
    And I should not see the "header"
    And I should not see the "footer"

# not sure this can easily fail ... maybe check when we change?
# more effective to test results of selecting options? requires we stand up all the data? maybe not?
  Scenario: Category selections maintain defaults following search
    Given I select 'Any' from 'Type of Activity'
    And no 'Location' is selected
    And no 'Self Care Categories' are selected
    When I select 'Group' from 'Type of Activity' 
    And I select 'Westminster' from 'Location'
    And I select 'Autism' from 'Self Care Categories'
    And I press "Search"
    Then 'Type of Activity' is set to 'Group'
    And 'Location' is set to 'Westminster'
    And 'Self Care Categories' is set to 'Autism'
    And I should not see the navbar 
