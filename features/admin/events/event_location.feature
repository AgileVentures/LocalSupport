@vcr @billy
Feature: Event Location
  As a super Admin
  So that others can see events location
  I would like to add an event address field to the system

  Background: Data has been added to the database
    Given the following organisations exist:
      | name            | description          | address        | postcode | website       |
      | Cats Are Us     | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
    
    Given the following users are registered:
      | email                         | password | superadmin | confirmed_at         | organisation |
      | registered-user-1@example.com | pppppppp | true       | 2007-01-01  10:00:00 | Friendly     |
    
    And the following events exist:
      | title   | description        | organisation | start_date | end_date   | address        |
      | Care    | Care for animals   | Cats Are Us  | today      | today      | 64 pinner road |
    
    And cookies are approved
    And I am signed in as a superadmin

  Scenario: New event form has event address field
    When I visit the new event page
    Then I should see a text field for "event_address"
  
 Scenario: Super admin creates a new event with an event address
    Given I visit the new event page
    And I fill in the new event page validly
    When I fill in "event_address" with "1427 Leon Parks"
    And I press "Create Event"
    Then I should see "Event was successfully created"
  
 Scenario: The event shows on the map
    When I visit the events page
    Then I should see "Care for animals" event description marker in "Care" event location in the map
