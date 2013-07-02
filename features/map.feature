Feature: Map of local charities
  As a local resident
  So that I can get support for a specific condition
  I want to find contact details for a local service specific to my need
  Tracker story ID: https://www.pivotaltracker.com/story/show/45757075

Background: 
   Given the following organizations exist:
  | name                            | description                      | address        | postcode | website       |
  | Harrow Bereavement Counselling  | Harrow Bereavement Counselling   | 34 pinner road | HA1 4HZ  | http://a.com/ |
  | Indian Elders Association       | Care for the elderly             | 64 pinner road | HA1 4HA  | http://b.com/ |
  | Age UK                          | Care for the Elderly             | 84 pinner road | HA1 4HF  | http://c.com/ |

@show
@javascript
Scenario: Show all charities on homepage map
  Given I am on the home page
  Then I should see contact details for "Indian Elders Association", "Age UK" and "Harrow Bereavement Counselling"
  #And show me the page
  And I should see "Indian Elders Association", "Age UK" and "Harrow Bereavement Counselling" in the map centered on local organizations
@javascript
Scenario: Clickable hyperlinks to charity homepage in map

  Given I am on the home page
  Then show me the page
  And I should see hyperlinks for "Indian Elders Association", "Age UK" and "Harrow Bereavement Counselling" in the map
