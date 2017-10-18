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