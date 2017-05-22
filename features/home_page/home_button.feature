Feature: Home button in header
  As a local resident
  So that I can easily return to the home page
  I want to have a home button in the header


  Background: organisations have been added to database

    Given the following organisations exist:
      | name                           | description                  | address        | postcode | website       |
      | Harrow Bereavement Counselling | Counselling for the bereaved | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association      | Care for the elderly         | 64 pinner road | HA1 4HZ  | http://b.com/ |
      | Age UK                         | Care for the Elderly         | 84 pinner road | HA1 4HZ  | http://c.com/ |

    Given the following volunteer opportunities exist:
      |title              | description            | organisation |
      |Litter Box Scooper | Assist with sanitation | Age UK |

  @vcr
  Scenario Outline: Find help with care for elderly
    Given I visit the <page>
    Then I should see an <status> home button in the header
    And I click "Home"
    Then I should be on the home page
    Examples:
      | page                                              | status   |
      | home page                                         | active   |
      | volunteer opportunities page                      | inactive |
      | organisations index page                          | inactive |
      | show page for the organisation named "Age UK"     | inactive |
