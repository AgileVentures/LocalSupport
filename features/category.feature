Feature: Categories of charities
  As a member of the public, or local charity worker
  In order to find a particular type of service
  I want to navigate through categories to find service
  Tracker story ID: https://www.pivotaltracker.com/story/show/46217161

  Background: organizations have been added to database
  Given the following organizations exist:
  | name                            | description                      | address        | postcode | website       |
  | Harrow Bereavement Counselling  | Harrow Bereavement Counselling   | 34 pinner road | HA1 4HZ  | http://a.com/ |
  | Indian Elders Association       | Care for the elderly             | 64 pinner road | HA1 4HA  | http://b.com/ |
  | Age UK                          | Care for the Elderly             | 84 pinner road | HA1 4HF  | http://c.com/ |

  Scenario: Search for organizations in the "Animal Welfare" category
  #Given I have at least 3 organizations in the "Animal Welfare" category
  Given I am on the home page
  And I select the "Animal Welfare" category
  Then I should see contact details for "Indian Elders Association" and "Age UK"
