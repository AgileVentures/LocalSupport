Feature: Home button in header
  As a local resident
  So that I can easily return to the home page
  I want to have a home button in the header


  Background: organisations have been added to database

    Given the following organisations exist:
      | name                           | description                  | address        | postcode | website       |
      | Harrow Bereavement Counselling | Counselling for the bereaved | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association      | Care for the elderly         | 64 pinner road | HA1 4HA  | http://b.com/ |
      | Age UK                         | Care for the Elderly         | 84 pinner road | HA1 4HF  | http://c.com/ |

  Scenario: Find help with care for elderly
    Given I visit the home page
    Then I should see a home button in the header
