Feature: As a potential volunteer
  So that I can find an opportunity that interests me
  I would like to be able to search ops by keyword

  Background:
    Given the following organisations exist:
      | name                      | description          | address        | postcode | website       |
      | Cats Are Us               | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |
    Given the following volunteer opportunities exist:
      | title              | description                                     | organisation              |
      | Litter Box Scooper | Assist with feline sanitation   test@test.com   | Cats Are Us               |
      | Office Support     | Help with printing and copying. http://test.com | Indian Elders Association |

  Scenario: Search a list of current volunteer opportunities by existent keywords
    Given cookies are approved
    And I visit the volunteer opportunities page
    And  I fill in "Search Text" with "help" within the main body
    And I press "Search"
    Then I should see "Office Support" 
    And I should not see "Litter Box Scooper" within "orgs_scroll"

  Scenario: Search a list of current volunteer opportunities by non existent keywords
    Given cookies are approved
    And I visit the volunteer opportunities page
    And  I fill in "Search Text" with "non existent text" within the main body
    And I press "Search"
    Then I should see "Sorry, it seems we don't have quite what you are looking for." 

  Scenario: Query string is visible after search
    Given cookies are approved
    And I visit the volunteer opportunities page
    And  I fill in "Search Text" with "search words" within the main body
    And I press "Search"
    Then the search box should contain "search words"
