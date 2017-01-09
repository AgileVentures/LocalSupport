@time_travel
Feature: Charity worker is reminded annually to edit own charity profile
  As a charity worker
  So that I remember to update my details
  I want to be reminded annually to update my details
  Tracker story ID: https://www.pivotaltracker.com/story/show/65363894

  Background: organisations have been added to database
    Given today's date is 1980-12-25
    Given the following organisations exist:
    | name           | description               | address        | postcode | telephone | email                   |
    | Friendly       | Bereavement Counselling   | 34 pinner road | HA1 4HZ  | 020800000 | superadmin@friendly.org |

    Given the following users are registered:
    | email                              | password | organisation | confirmed_at         |
    | superadmin@friendly.org            | pppppppp | Friendly     | 2007-01-01  10:00:00 |
    And cookies are approved

  @javascript
  @vcr @billy
  Scenario: Org owner is reminded to update details after a year
    Given I travel a year plus "0" days into the future
    And I visit the home page
    And I click "Login"
    When I sign in as "superadmin@friendly.org" with password "pppppppp" with javascript
    Then I should see the call to update details for organisation "Friendly"
  @javascript
  @billy
  Scenario: Org owner is not reminded to update details prior to a year
    Given I travel a year plus "-1" days into the future
    And I visit the home page
    And I click "Login"
    When I sign in as "superadmin@friendly.org" with password "pppppppp" with javascript
    Then I should not see the call to update details for organisation "Friendly"
