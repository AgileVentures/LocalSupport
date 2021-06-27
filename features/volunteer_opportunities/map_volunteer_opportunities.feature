@vcr @javascript @billy @maps
Feature: As a member of the public
  So that I can see where organisations with volunteer opportunities are located
  I would like to see a map of volunteer opportunities
  Tracker story ID: https://www.pivotaltracker.com/story/show/66059862

  @javascript @billy
  Scenario Outline: See a list of local volunteer ops with same coordiantes in same marker popup
    Given the following organisations exist:
      | name          | description          | address        | postcode | website       |
      | Cats Are Us   | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Office Primer | Care for the elderly | 34 pinner road | HA1 4HZ  | http://b.com/ |
    Given the following volunteer opportunities exist:
      | title          | description                     | organisation  | address        | postcode |
      | Animal care    | Assist with feline sanitation   | Cats Are Us   | 34 pinner road | HA1 4HZ  |
      | Office Support | Help with printing and copying. | Office Primer | 34 pinner road | HA1 4HZ  |
    Given the following doit volunteer opportunities exist:
      | title          | description                     | latitude | longitude |
      | Animal care    | Assist with feline sanitation   | 51.581475  | -0.3440408 |
      | Office Support | Help with printing and copying. | 51.581475  | -0.3440408 |
    Given I visit the volunteer opportunities page
    And cookies are approved
    Then I take a screenshot
    Then I should see 1 markers in the map
    And the map should show the opportunity titled <title>
    Examples:
      | title          |
      | Animal care    |
      | Office Support |

  Scenario Outline: See a list of do-it volunteer ops with same coordiantes in same marker popup
    Given the following doit volunteer opportunities exist:
      | title          | description                     | latitude | longitude |
      | Eldery care    | Assist eldery people            | 51.5943  | -0.334769 |
      | Office Support | Help with printing and copying. | 51.5943  | -0.334769 |
    Given I visit the volunteer opportunities page
    And cookies are approved
    Then I should see 1 markers in the map
    And the map should show the opportunity titled <title>
    Examples:
      | title          |
      | Eldery care    |
      | Office Support |

  @javascript @billy
  Scenario Outline: See a list of do-it and local volunteer ops with same coordiantes in same marker popup
    Given the following organisations exist:
      | name          | description          | address        | postcode | website       |
      | Cats Are Us   | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Office Primer | Care for the elderly | 34 pinner road | HA1 4HZ  | http://b.com/ |

    Given the following volunteer opportunities exist:
      | title          | description                     | organisation  | address                       | postcode |
      | Animal care    | Assist with feline sanitation   | Cats Are Us   | 43 Claremont Road, Wealdstone | HA3 7AU  |
      | Office Support | Help with printing and copying. | Office Primer | 43 Claremont Road, Wealdstone | HA3 7AU  |

    Given the following doit volunteer opportunities exist:
      | title        | description                     | latitude   | longitude  |
      | Eldery care  | Assist eldery people            | 51.5986313 | -0.3356556 |
      | Office Tasks | Help with printing and copying. | 51.5986313 | -0.3356556 |
    Given I visit the volunteer opportunities page
    And cookies are approved
    Then I should see 1 markers in the map
    And the map should show the opportunity titled <title>
    Examples:
      | title          |
      | Eldery care    |
      | Office Tasks   |
      | Animal care    |
      | Office Support |

  Scenario: Imported "reachskills" volunteer ops with nil coords are assigned default coords
    Given reachskills opportunities are imported with nil coordinates
    Then there should be zero nil coordinates
    And 1 default Harrow coordinates should be assigned

  @javascript @billy
  Scenario: See map when editing my volunteer opportunity

    Given the following organisations exist:
      | name        | description    | address        | postcode | website       |
      | Cats Are Us | Animal Shelter | 34 pinner road | HA1 4HZ  | http://a.com/ |
    Given the following users are registered:
      | email                         | password | organisation | confirmed_at         |
      | registered_user-1@example.com | pppppppp | Cats Are Us  | 2007-01-01  10:00:00 |
    Given the following volunteer opportunities exist:
      | title              | description                   | organisation |
      | Litter Box Scooper | Assist with feline sanitation | Cats Are Us  |
    And I am signed in as a charity worker related to "Cats Are Us"
    And I visit the edit page for the volunteer_op titled "Litter Box Scooper"
    Then the map should show the opportunity titled Litter Box Scooper

  @javascript @billy
  Scenario: See map when editing my volunteer opportunity
    Given I visit the volunteer opportunities page
    Then the Do-it word in the legend should be a hyperlink to the Do-it website

  @javascript @billy
  Scenario: Infowindow appears when mouse hovers over volunteer opportunity in table
    Given the following organisations exist:
      | name          | description          | address        | latitude   | longitude  |
      | Cats Are Us   | Animal Shelter       | 34 pinner road | 51.5986313 | -0.3356556 |
      | Office Primer | Care for the elderly | 34 pinner road | 61.1116313 | 7.3356556  |
    Given the following volunteer opportunities exist:
      | title              | description                     | organisation  |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us   |
      | Office Support     | Help with printing and copying. | Office Primer |
    And I visit the volunteer opportunities page
    And cookies are approved
    Then I should see an infowindow when mouse enters volop in table:
      | Litter Box Scooper | Office Support |
    Then I should not see an infowindow when mouse leaves volop in table:
      | Litter Box Scooper | Office Support |

  @javascript @billy
  Scenario: Infowindow continues to work when mouse hovers over volunteer opportunity without long and lat values in table
    Given the following organisations exist:
      | name          | description          | address        | latitude   | longitude |
      | Cats Are Us   | Animal Shelter       | 34 pinner road |            |           |
      | Office Primer | Care for the elderly | 34 pinner road | 61.1116313 | 7.3356556 |
    Given the following volunteer opportunities exist:
      | title              | description                     | organisation  |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us   |
      | Office Support     | Help with printing and copying. | Office Primer |
    And I visit the volunteer opportunities page
    And cookies are approved
    Then I shouldn't see an infowindow when mouse enters volop without long and lat in table:
      | Litter Box Scooper |
    And I should see an infowindow when mouse enters volop with long and lat in table:
      | Office Support |
