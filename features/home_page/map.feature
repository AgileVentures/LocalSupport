Feature: Map of local charities
  As a local resident
  So that I can get support for a specific condition
  I want to find contact details for a local service specific to my need
  Tracker story ID: https://www.pivotaltracker.com/story/show/45757075
  Tracker story ID: https://www.pivotaltracker.com/story/show/52317013
Background: 
   Given the following organizations exist:
  | name                            | description                      | address        | postcode | website       |
  | Harrow Bereavement Counselling  | Harrow Bereavement Counselling   | 34 pinner road | HA1 4HZ  | http://a.com/ |
  | Indian Elders Association       | Care for the elderly             | 64 pinner road | HA1 4HA  | http://b.com/ |
  | Age UK                          | Care for the Elderly             | 84 pinner road | HA1 4HF  | http://c.com/ |
  | Youth UK                        | Care for the Very Young          | 84 pinner road | HA1 4HF  | http://d.com/ |

   Given the following users are registered:
  | email             | password | organization | confirmed_at |
  | registered_user-3@example.com | pppppppp | Youth UK  | 2007-01-01  10:00:00 |
@show
@javascript
Scenario: Show all charities on homepage map
  Given I am on the home page
  Then I should see contact details for "Indian Elders Association", "Age UK" and "Harrow Bereavement Counselling"
  #And show me the page
  And I should see "Indian Elders Association", "Age UK" and "Harrow Bereavement Counselling" in the map centered on local organizations

#@javascript
# TODO work out how to do testing on gmap
Scenario: Clickable hyperlinks to charity homepage in map
  Given I am on the home page
  And I should see hyperlinks for "Indian Elders Association", "Age UK" and "Harrow Bereavement Counselling" in the map

Scenario: Changing address on the map changes the map coordinates
    Given I am on the home page
    Then the coordinates for "Harrow Bereavement Counselling" and "Youth UK" should not be the same
    And the coordinates for "Age UK" and "Youth UK" should be the same
    Given cookies are approved
    When I am signed in as a charity worker related to "Youth UK"
    And I update "Youth UK" charity address to be "34 pinner road"
    And I am on the home page
    Then the coordinates for "Harrow Bereavement Counselling" and "Youth UK" should be the same
    Then the coordinates for "Age UK" and "Youth UK" should not be the same

