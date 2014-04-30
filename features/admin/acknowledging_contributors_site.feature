Feature: Acknowledging Contributors
  As a site administrator
  So that I can encourage continued support from vendors and developers
  I want to see acknowledgement of support on every page

Background: 

  Scenario Outline: Display acknowledgements
    Given I am on the <page>
    Then I should see the "Agile Ventures" image linked to contributors
    And I should see the "Ninefold" image linked to "https://ninefold.com"
  Examples:
    | page                 |
    | home page            |
    | charity search page  |
    | new charity page     |

