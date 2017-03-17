Feature: Super Admin creating an event
  As a super Admin
  So that I can publicize events for an organisation
  I would like to add an event to the system

  Background:
    Given the following users are registered:
      | email                         | password | superadmin | confirmed_at         | organisation |
      | registered-user-1@example.com | pppppppp | true       | 2007-01-01  10:00:00 | Friendly     |
      | registered-user-2@example.com | pppppppp | false      | 2007-01-01  10:00:00 |              |

  Scenario: Unsuccessfully attempt to create event without being signed-in
    When I visit the new event page
    Then I should be on the sign in page

  Scenario: Successfully create an event while being signed-in as superadmin
    Given I am signed in as a superadmin
    And I visit the home page
    And I click "New Event"
    Given I fill in the new event page validly
    Then I press "Create Event"
    Then I should see "Event was successfully created"

  # Scenario: Get validation error creating new event with empty fields
    # Given I am signed in as a superadmin
    # And I visit home page
    # And I follow "New Event"
    # And I press "Create Event"
    # Then I should see "Title can't be blank"
    # Then I should see "Description can't be blank"

  Scenario: Logged in non-superadmin user should not see new event link
    Given I am signed in as a non-superadmin
    Given I visit the home page
    Then I should not see "New Event"

  # Scenario: non logged in user should not see new event link
    # Given I visit the home page
    # Then I  should not see a new event link

  # Scenario: Non-superadmin unsuccessfully attempts to create an event
    # Given I am signed in as a non-superadmin
    # And I create "Unwanted" event
    # Then I should be on the events index page
    # Then I should see permission denied
    # And I should not see "Event was successfully created"
    # And "Unwanted" event should not exist

  # Scenario: Successfully create event while being signed in as superadmin
    # Given I am signed in as a superadmin
    # And I visit home page
    # And I follow "New Event"
    # And I fill the new event page validity including the following attributes:
    #   | title       |
    #   | description |
    #   | start date  |
    #   | end date    |
    # And I press "Create Event"
    # Then I should see "Event was successfully created"

