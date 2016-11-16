Feature: Would like the site to appear high in Google's listing
  As a Site Super Admin
  So people can find us
  I want us to rank highly in Google's listings

  Background: organisations have been added to database
    Given the following organisations exist:
      | name     | description             | address        | postcode | telephone | website             | email                  |
      | Friendly | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.org | superadmin@friendly.xx |
    And the following volunteer opportunities exist:
      | title             | description           | organisation |
      | Helping Volunteer | Helping the earlderly | Friendly     |

  Scenario: Meta Title and Description for home page
    Given I visit the organisations index page
    Then I should have a page with a title: "Harrow volunteering"
    And I should see "Harrow Community Network is a nonprofit workers"

  Scenario: Meta Title and Description for organisation show page
    Given I visit the show page for the organisation named "Friendly"
    Then I should have a page with a title: "Friendly | Harrow volunteering"

  Scenario: Meta Title and Description for volunteers show page
    Given I visit the show page for the volunteer_op titled "Helping Volunteer"
    Then I should have a page with a title: "Helping Volunteer | Harrow volunteering"
