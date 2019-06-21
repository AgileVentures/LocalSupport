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
    | name               | description                     | organisation              |
    | Litter Box Scooper | Help with feline sanitation     | Cats Are Us               |
    | Office Support     | Help with printing and copying. | Indian Elders Association |

  Scenario: See a volunteer opportunity and hyperlink
    Given I visit the show page for the service named "Office Support"
    Then I should see:
      | name          | description                                      | organisation              |
      | Office Support | Help with printing and copying.                | Indian Elders Association |
    And I click "Indian Elders Association" organisation link
    Then I should be on the show page for the organisation named "Indian Elders Association"
    Then I visit the show page for the services named "Office Support"
    And I click "Indian Elders Association" breadcrumb link
    Then I should be on the show page for the organisation named "Indian Elders Association"