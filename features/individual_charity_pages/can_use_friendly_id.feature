Feature: Charity worker should see friendly url address
  As a charity worker
  So that I can use and share url of my charity more comfortably
  I want to see the name of my charity in the web page address
  Tracker story ID: https://www.pivotaltracker.com/story/show/89294872
  
  Background: organisations have been added to database
    Given the following organisations exist:
      | name       | description             | address        | postcode | telephone | website             | email             |
      | Friendly   | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.org | superadmin@friendly.xx |
      | Unfriendly guys | Bunch of jerks          | 30 pinner road |          | 020800010 |                     |                   |
    Given the following users are registered:
      | email                         | password | organisation | confirmed_at         |
      | registered_user-1@example.com | pppppppp | Friendly     | 2007-01-01  10:00:00 |
      | registered_user-2@example.com | pppppppp | Unfriendly guys  | 2007-01-01  10:00:00 |
      
  @vcr
  Scenario: I get to the show page and see organisation's name in the url
    Given I visit the show page for the organisation named "Friendly" using friendly url
    Then the URL should contain "organisations/friendly"
    
  @vcr
  Scenario: I get to the edit page and see organisation's name in the url
    Given I am signed in as a charity worker related to "Unfriendly guys"
    Given I visit the edit page for the organisation named "Unfriendly guys" using friendly url
    Then the URL should contain "organisations/unfriendly-guys/edit"
    
  # Should I define a step to reverse the case - I write an url and I should be 
  # on the right page? PB
      