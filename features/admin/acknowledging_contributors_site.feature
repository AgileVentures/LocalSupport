Feature: Acknowledging Contributors
  As a site superadministrator
  So that I can encourage continued support from vendors and developers
  I want to see acknowledgement of support on every page

  Background:

  Scenario Outline: Display acknowledgements
    Given I visit the <page> page
    Then I should see the "Agile Ventures" image linked to contributors
#    And I should see the "Do-it" image linked to "https://do-it.org/"
    And I should see the "Ssl-secure-badge" image linked to "https://www.expeditedssl.com/simple-ssl-scanner/scan?target_domain=www.harrowcn.org.uk"
  Examples:
    | page                |
    | home                |
    | organisations index |
    | new organisation    |

  Scenario Outline: Do-it logo is displayed when doit_volunteer_opportunities flag is enabled
    Given that the doit_volunteer_opportunities flag is enabled
    Given I visit the <page> page
    Then I should see the "Do-it" image linked to "https://do-it.org/"
    Examples:
      | page                |
      | home                |
      | organisations index |
      | new organisation    |
