Feature: Show Individual Services
  As a member of a health care team
  So that I can contact or learn about a service available in my Primary Care Network area
  I would like to see more details on that service
  
  Background: organisations with services have been added to database

  Given the following organisations exist:
    | name                      | description          | address        | postcode | website       |
    | Cats Are Us               | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
    | Indian Elders Association | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |
  And the following services exist:
    | name               | description                                     | organisation              | address    | postcode |
    | Litter Box Scooper | Help with feline sanitation   test@test.com     | Cats Are Us               |           |          |
    | Office Support     | Help with printing and copying. http://test.com | Indian Elders Association |           |          |
    | Driving Support    | Help with printing and copying. http://test.com | Indian Elders Association | Station Rd | HA8 7BD  |

  Scenario: See a volunteer opportunity and hyperlink
    Given I visit the show page for the service named "Office Support"
    Then I should see:
      | name          | description                                      | organisation              |
      | Office Support | Help with printing and copying. http://test.com | Indian Elders Association |
    And I click "Indian Elders Association" organisation link
    Then I should be on the show page for the organisation named "Indian Elders Association"
    Then I visit the show page for the services named "Office Support"
    And I click "Indian Elders Association" breadcrumb link
    Then I should be on the show page for the organisation named "Indian Elders Association"

  Scenario: See URLs in services pages are hyperlinked
    Given I visit the show page for the service named "Office Support"
    Then the page includes a hyperlink to "http://test.com"

  Scenario: See emails in services pages are hyperlinked
    Given I visit the show page for the service named "Litter Box Scooper"
    Then the page includes email hyperlink "test@test.com"

  Scenario: See service location with different address
    Given I visit the show page for the service named "Driving Support"
    Then I should see "Service location: Station Rd, HA8 7BD" 
    
  Scenario: See search form on show page
    Given I visit the show page for the service named "Office Support"
    Then I should see a search form
