Feature: Admin editing charity
  As a site admin
  So that I can ensure that charity information (for someone else) is correct (including adding a new organisation)
  I want to be able to edit/delete/add any charity information
  Tracker Story ID: https://www.pivotaltracker.com/story/show/50368203

  Background: organisations have been added to database
    Given the following organisations exist:
      | name           | description             | address        | postcode | telephone |
      | Friendly       | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 |
      | Friendly Clone | Quite Friendly!         | 30 pinner road | HA1 4HZ  | 020800010 |
    And the following users are registered:
      | email             | password | admin | confirmed_at |  organisation |
      | registered-user-1@example.com | pppppppp | true  | 2007-01-01  10:00:00 |  Friendly |
      | registered-user-2@example.com | pppppppp | false | 2007-01-01  10:00:00 |           |
    And cookies are approved

  Scenario: Admin successfully changes the address of a charity
    Given I am signed in as a admin
    And I update "Friendly" charity address to be "30 pinner road"
    Then the address for "Friendly" should be "30 pinner road"

#TODO Refactor into integration test that posts to update method
#  Scenario: Non-admin unsuccessfully attempts to change the address of a charity
#    Given I am signed in as a non-admin
#    And I furtively update "Friendly" charity address to be "30 pinner road"
#    Then I should see "You don't have permission"
#    And "Friendly" charity address is "34 pinner road"

  Scenario: Non-admin sees no permission error when visiting the edit form for charity
    Given I am signed in as a non-admin
    And I visit the edit page for the organisation named "Friendly"
    Then I should be on the show page for the organisation named "Friendly"
    And I should see permission denied

