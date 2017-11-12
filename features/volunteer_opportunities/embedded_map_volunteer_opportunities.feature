@vcr @javascript @billy @maps
Feature: As a member of the public visiting a partner site
  So that I can see where organisations with volunteer opportunities are located
  I would like to see an embedded map of volunteer opportunities
  Tracker story ID: https://www.pivotaltracker.com/story/show/149069421

  Scenario Outline: See markers for do-it volunteer ops on the map
    Given the following doit volunteer opportunities exist:
      | title           | description                     | latitude    | longitude  |
      | Eldery care     | Assist eldery people            | 51.5943     | -0.334769  |
      | Office Support  | Help with printing and copying. | 51.5943     | -0.334769  |
    Given I visit the embedded map page
    Then I should see 1 markers in the map
    And the map should show the opportunity titled <title>
    Examples:
      | title             |
      | Eldery care       |
      | Office Support    |

  Scenario: See opportunities pop-up when marker is clicked

    Given the following organisations exist:
      | name                      | description          | address        | latitude    | longitude  |
      | Cats Are Us               | Animal Shelter       | 34 pinner road | 60.1116313  |  7.3356556 |
      | Office Primer             | Care for the elderly | 64 pinner road | 61.1116313  |  7.3356556 |
    Given the following volunteer opportunities exist:
      | title              | description                     | organisation             | source |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us              | local  |
      | Office Support     | Help with printing and copying. | Office Primer            | local  |
    Given I visit the embedded map page
    Then I should see an infowindow when I click on the volunteer opportunities map markers:
      | Cats Are Us | Office Primer |

  Scenario: See only the map container rendered in the body

    Given the following organisations exist:
      | name                      | description          | address        | latitude    | longitude  |
      | Cats Are Us               | Animal Shelter       | 34 pinner road | 60.1116313  |  7.3356556 |
      | Office Primer             | Care for the elderly | 64 pinner road | 61.1116313  |  7.3356556 |
    Given the following volunteer opportunities exist:
      | title              | description                     | organisation             |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us              |
      | Office Support     | Help with printing and copying. | Office Primer            |
    Given I visit the embedded map page
    Then I should only see the map container element on the page
