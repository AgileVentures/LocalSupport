Feature: Would like the site to appear high in Google's listing
  As a Site Super Admin
  So people can find us
  I want us to rank highly in Google's listings

  Background: organisations have been added to database
    Given the following organisations exist:
      | name       | description             | address        | postcode | telephone | website             | email             |
      | Friendly   | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.org | superadmin@friendly.xx |

  # Background: volunteers have been added to database
  #   Given the following volunteers exist:
  #     | Title             | description           |
  #     | Helping Volunteer | Helping the earlderly |

  Scenario: Meta Title and Description for home page
    Given I visit the organisations index page
    Then I should have a page with a title: "Harrow Community Network"
    And I should see "Harrow Community Network is a nonprofit workers"

  Scenario: Meta Title and Description for organisation show page
    Given I visit the show page for the organisation named "Friendly"
    Then I should have a page with a title: "Friendly | Harrow Community Network | Harrow volunteering"

  Scenario: Meta Title and Description for volunteers show page
    Given I visit the show page for the volunteer named "Helping Volunteer"
    Then I should have a page with a title: "Friendly Volunteer | Harrow volunteering"
