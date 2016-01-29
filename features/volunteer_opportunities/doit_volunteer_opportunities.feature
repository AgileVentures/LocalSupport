Feature: As a member of the public
  So that I can see where organisations with volunteer opportunities are located
  I would like to see a map of do-it volunteer opportunities

  @javascript
  Scenario: See a map of current doit volunteer opportunities
    Given that the doit_volunteer_opportunities flag is enabled
    And I visit the volunteer opportunities page
    And cookies are approved
    And I should see 16 markers in the map