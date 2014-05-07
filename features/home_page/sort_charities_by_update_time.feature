Feature: Order organizations by most recently updated
  As any user
  So that I can see which charities have been updated most recently
  I want to be able to sort charities by update time
  TTracker story ID: https://www.pivotaltracker.com/story/show/50082619

Background: organizations have been added to database
  
  Given the following organizations exist:
  | name                            | updated_at            | address        |
  | Harrow Bereavement Counselling  | "2013-01-23 15:54:34" | 34 pinner road |
  | Harrow Elders Association       | "2013-02-23 15:54:34" | 64 pinner road |
  | Harrow Age UK                   | "2013-03-23 15:54:34" | 84 pinner road |

Scenario: Most recently updated charity shows at the top of the list 
  Given I update the "Harrow Elders Association" 
  And I visit the home page
  Then I should see "Harrow Elders Association" before "Age UK"
  And I should see "Harrow Age UK" before "Harrow Bereavement Counselling"
 
Scenario: Most recently updated charity shows at the top of the list 
  Given I visit the home page
  Then I should see "Harrow Elders Association" before "Harrow Bereavement Counselling"
  And I should see "Harrow Age UK" before "Harrow Elders Association"
  When I update the "Harrow Elders Association"
  And I search for "Harrow"
  Then I should see "Harrow Elders Association" before "Harrow Bereavement Counselling"
