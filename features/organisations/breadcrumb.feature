Feature: View Breadcrumbs
  As a user of the community
  So that I can easily backtrace my steps in the application
  I would like to have breadcrumbs properly displayed

  Background: organisations have been added to database

    Given the following organisations exist:
      | name                           | description                  | address        | postcode | website       |
      | Harrow Bereavement Counselling | Counselling for the bereaved | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association      | Care for the elderly         | 64 pinner road | HA1 4HZ  | http://b.com/ |
      | Age UK                         | Care for the Elderly         | 84 pinner road | HA1 4HZ  | http://c.com/ |

  Scenario: User visits organisations home page
    Given I visit the organisations index page
    Then I should see a link to "home" page "/"
    And I should see "home » All Organisations"

  Scenario: User visits organisation from organisations index page
    Given I visit the organisations index page
    When I click "Harrow Bereavement Counselling"
    Then I should see a link to "home" page "/"
    And I should see a link to "All Organisations" page "/organisations"
    And I should see "home » All Organisations » Harrow Bereavement Counselling"
