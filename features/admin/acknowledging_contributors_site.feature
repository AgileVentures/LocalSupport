Feature: Acknowledging Contributors
  As a site superadministrator
  So that I can encourage continued support from vendors and developers
  I want to see acknowledgement of support on every page

  Background:

  Scenario Outline: Display acknowledgements
    Given I visit the <page> page
    Then I should see the "Agile Ventures" image linked to contributors
    And I should see the "Ssl-secure-badge" image linked to "https://www.expeditedssl.com/simple-ssl-scanner/scan?target_domain=www.harrowcn.org.uk"
  Examples:
    | page                |
    | home                |
    | organisations index |
    | new organisation    |
