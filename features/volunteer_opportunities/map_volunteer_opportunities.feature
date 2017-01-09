@vcr @javascript @billy
Feature: As a member of the public
  So that I can see where organisations with volunteer opportunities are located
  I would like to see a map of volunteer opportunities
  Tracker story ID: https://www.pivotaltracker.com/story/show/66059862

  Scenario Outline: See a list of local volunteer ops with same coordiantes in same maker popup
    Given the following organisations exist:
      | name            | description          | address        | postcode | website       |
      | Cats Are Us     | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Office Primer   | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |
    Given the following volunteer opportunities exist:
      | title           | description                     | organisation  | address        | postcode |
      | Animal care     | Assist with feline sanitation   | Cats Are Us   | 34 pinner road | HA1 4HZ  |
      | Office Support  | Help with printing and copying. | Office Primer | 34 pinner road | HA1 4HZ  |
    Given I visit the volunteer opportunities page
    And cookies are approved
    Then I should see 1 markers in the map
    And the map should show the opportunity titled <title>
    Examples:
      | title             |
      | Animal care       |
      | Office Support    |

  Scenario Outline: See a list of do-it volunteer ops with same coordiantes in same maker popup
    Given the following doit volunteer opportunities exist:
      | title           | description                     | latitude    | longitude  |
      | Eldery care     | Assist eldery people            | 51.5943     | -0.334769  |
      | Office Support  | Help with printing and copying. | 51.5943     | -0.334769  |
    Given I visit the volunteer opportunities page
    And cookies are approved
    Then I should see 1 markers in the map
    And the map should show the opportunity titled <title>
    Examples:
      | title             |
      | Eldery care       |
      | Office Support    |

  Scenario Outline: See a list of do-it and local volunteer ops with same coordiantes in same maker popup
    Given the following organisations exist:
      | name            | description          | address        | postcode | website       |
      | Cats Are Us     | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Office Primer   | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |

    Given the following volunteer opportunities exist:
      | title           | description                     | organisation  | address        | postcode |
      | Animal care     | Assist with feline sanitation   | Cats Are Us   | 43 Claremont Road, Wealdstone | HA3 7AU  |
      | Office Support  | Help with printing and copying. | Office Primer | 43 Claremont Road, Wealdstone | HA3 7AU  |

    Given the following doit volunteer opportunities exist:
      | title           | description                     | latitude    | longitude   |
      | Eldery care     | Assist eldery people            | 51.5986313  | -0.3356556  |
      | Office Tasks    | Help with printing and copying. | 51.5986313  | -0.3356556  |
    Given I visit the volunteer opportunities page
    And cookies are approved
    Then I should see 1 markers in the map
    And the map should show the opportunity titled <title>
    Examples:
      | title             |
      | Eldery care       |
      | Office Tasks      |
      | Animal care       |
      | Office Support    |

  @javascript @billy
  Scenario: See map when editing my volunteer opportunity

    Given the following organisations exist:
      | name                      | description          | address        | postcode | website       |
      | Cats Are Us               | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
    Given the following users are registered:
      | email                         | password | organisation | confirmed_at         |
      | registered_user-1@example.com | pppppppp | Cats Are Us  | 2007-01-01  10:00:00 |
    Given the following volunteer opportunities exist:
      | title              | description                     | organisation              |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us               |
    And I am signed in as a charity worker related to "Cats Are Us"
    And I visit the edit page for the volunteer_op titled "Litter Box Scooper"
    Then the map should show the opportunity titled Litter Box Scooper


  @javascript @billy
  Scenario: See map when editing my volunteer opportunity
    Given I visit the volunteer opportunities page
    Then the Do-it word in the legend should be a hyperlink to the Do-it website
