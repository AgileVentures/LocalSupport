Feature: Web page owned by each charity
  As a charity worker
  So that I can increase my charity's visibility
  I want to have a web presence
  Tracker story ID: https://www.pivotaltracker.com/story/show/45405153

  Background: organizations have been added to database
    Given the following organizations exist:
      | name       | description             | address        | postcode | telephone | website             | email             |
      | Friendly   | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.org | admin@friendly.xx |
      | Unfriendly | Bunch of jerks          | 30 pinner road |          | 020800010 |                     |                   |
    Given the following users are registered:
      | email                         | password | organization | confirmed_at         |
      | registered_user-1@example.com | pppppppp | Friendly     | 2007-01-01  10:00:00 |
      | registered_user-2@example.com | pppppppp |              | 2007-01-01  10:00:00 |
    And I visit the show page for the organization named "Friendly"

  Scenario: be able to view link to charity site on individual charity page
    Then I should see the external website link for "Friendly" charity

  Scenario: display charity title in a visible way
    Then I should see "Friendly" < tagged > with "h3"

  Scenario: show organization e-mail as link
    Then I should see a mail-link to "admin@friendly.xx"

  Scenario Outline: show labels if field is present
    Then I should see "<label>"
  Examples:
    | label    |
    | Postcode |
    | Email    |
    | Website  |

  Scenario Outline: hide labels if field is empty
    Given I visit the show page for the organization named "Unfriendly"
    Then I should not see "<label>"
  Examples:
    | label    |
    | Postcode |
    | Email    |
    | Website  |




