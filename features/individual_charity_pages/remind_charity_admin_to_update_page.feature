Feature: Charity worker is reminded annually to edit own charity profile
  As a charity worker
  So that I remember to update my details
  I want to be reminded annually to update my details
  Tracker story ID: https://www.pivotaltracker.com/story/show/65363894

  Background: organisations have been added to database 
    Given the following organisations exist:
    | name           | description               | address        | postcode | telephone | email              |
    | Friendly       | Bereavement Counselling   | 34 pinner road | HA1 4HZ  | 020800000 | admin@friendly.org |

    Given the following users are registered:
    | email                         | password | organisation | confirmed_at         |
    | admin@friendly.org            | pppppppp | Friendly     | 2007-01-01  10:00:00 |
    And cookies are approved
  
  @javascript
  @time_travel
  Scenario: Org owner is reminded to update details after a year
    Given I travel "365" days into the future
    And I visit the home page
    And I click "Login"
    When I sign in as "admin@friendly.org" with password "pppppppp" with javascript
    Then I should see "You have not updated your details in over a year!" in the flash notice
  @javascript 
  @time_travel
  Scenario: Org owner is not reminded to update details prior to a year
    Given I travel "364" days into the future
    And I visit the home page
    And I click "Login"
    When I sign in as "admin@friendly.org" with password "pppppppp" with javascript
    Then I should not see "You have not updated your details in over a year!" in the flash notice 
