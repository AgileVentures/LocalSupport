Feature: As a member of the public
  So that I can see where organisations with volunteer opportunities are located
  I would like to see a map of do-it volunteer opportunities

  @javascript
  Scenario: See a map of current volunteer opportunities
    Given Do-it-api response is received and not empty
    And I visit the volunteer opportunities page
    And cookies are approved
    And I should see the following do_it markers in the map:
    | Scout Leader (volunteering with 10-14 year olds) 27th |
