Feature: Edit donation information feature
  As a charity worker
  So that I can attract funding
  I want to encourage local people to donate
  (charity worker can update a link to where they accept donations)
  
  Tracker story: https://www.pivotaltracker.com/s/projects/742821/stories/45405077

Background: organizations have been added to database 
  Given the following organizations exist:
  | name           | description               | address        | postcode | telephone |
  | Friendly       | Bereavement Counselling   | 34 pinner road | HA1 4HZ  | 020800000 |

Scenario: Successfully change the donation url for a charity
  Given I am on the edit charity page for "Friendly"
  And I edit the donation url to be "http://www.friendly.com/donate"
  And I press "Update Organization"
  Then I should be on the charity page for "Friendly"
  And I should see "Organization was successfully updated"
  And the donation_info URL for "Friendly" should refer to "http://www.friendly.com/donate"
