Feature: Editing an event from the event show page
  As a site user
  In order to be able to update planned activities
  I would like to be able to edit event details from the event show page

  Background: The following events have been added to the database
    Given the following organisations exist:
      | name            | description          | address        | postcode | website       |
      | Cats Are Us     | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Office Primer   | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |
    Given the following events exist:
      | title               | description       | organisation  | start_date          | end_date            |
      | Open Source Weekend | Good for everyone | Cats Are Us   | 2030-10-20 10:30:14 | 2030-10-20 17:00:00 |
      | Lazy Weekend        | Also good         | Office Primer | 2055-02-02 08:00:00 | 2055-02-02 17:00:00 |

  Scenario: As a logged in user, I can navigate to the edit page of an event
    Given that I am logged in as any user
    And I visit "Open Source Weekend" event
    And I click "Edit"
    Then I should be on the edit page for event "Open Source Weekend"

  Scenario: As a logged in user, I can edit an event
    Given that I am logged in as any user
    Then I visit the edit page for the event titled "Lazy Weekend"
    When I edit the details for "Lazy Weekend"
    Then I should see "Event has been succesfully updated"
    And I should see "Lazier Weekend"

  Scenario: As a logged in user, I should get an error when update event with invalid details
    Given that I am logged in as any user
    Then I visit the edit page for the event titled "Lazy Weekend"
    When I edit with invalid details for "Lazy Weekend"
    Then I should see "Your event was not updated successfully"

  Scenario: As a visitor, I cannot edit an event
    Given I am not logged in as any user
    And I visit "Open Source Weekend" event
    Then I should not see "Edit"
