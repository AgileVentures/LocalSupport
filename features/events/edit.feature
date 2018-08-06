Feature: View one event
  As a user of the community
  So that i can update an event details
  Then I should updated details of the events

  Background: The following events have been added to the database
    Given the following organisations exist:
      | name            | description          | address        | postcode | website       |
      | Cats Are Us     | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
    Given the following events exist:
      | title               | description       | organisation  | start_date          | end_date            |
      | Open Source Weekend | Good for everyone | Cats Are Us   | 2030-10-20 10:30:14 | 2030-10-20 17:00:00 |
    And the following users are registered:
      | email                 | password | superadmin | confirmed_at         | organisation |
      | superadmin@example.com     | pppppppp | true  | 2007-01-01  10:00:00 |              |
      | org-superadmin@example.com | pppppppp | false | 2007-01-01  10:00:00 | Friendly     |
      | user@example.com      | pppppppp | false | 2007-01-01  10:00:00 |              |
    And cookies are approved
    Given I am signed in as a non-superadmin

  Scenario: User visits event directly
    Given I visit "Open Source Weekend" event
    Then I should see "Edit Event"
    When I click "Edit Event"
    Then I should see "Edit Event"
    And I update "Open Source Weekend" name to be "Awesome Weekend"
    Then I press 'submit'
    Then I should see "Awesome Weekend"
