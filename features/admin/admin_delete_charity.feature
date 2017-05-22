Feature: Super Admin deleting charity
  As a Super Admin
  So that I can ensure that defunct charities are removed
  I want to be able to delete charities
  Tracker Story ID: https://www.pivotaltracker.com/story/show/59553308

  Background: organisations have been added to database
    Given the following organisations exist:
      | name     | description             | address        | postcode | telephone |
      | Friendly | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 |
    And the following proposed edits exist:
      |original_name | editor_email                  | name       | description             | address        | postcode | telephone | website               | email               | donation_info        | archived|
      |Friendly      | registered_user-2@example.com | Unfriendly | Mourning loved ones     | 30 pinner road | HA1 4HZ  | 520800000 | http://unfriendly.org | superadmin@unfriendly.xx | www.pleasedonate.com | false   |
      |Friendly      | registered_user-2@example.com | Unfriendly | Mourning loved ones     | 30 pinner road | HA1 4HZ  | 520800000 | http://unfriendly.org | superadmin@unfriendly.xx | www.pleasedonate.com | true    |
    And the following users are registered:
      | email                 | password | superadmin | confirmed_at         | organisation |
      | superadmin@example.com     | pppppppp | true  | 2007-01-01  10:00:00 |              |
      | org-superadmin@example.com | pppppppp | false | 2007-01-01  10:00:00 | Friendly     |
      | user@example.com      | pppppppp | false | 2007-01-01  10:00:00 |              |
    And cookies are approved

  @vcr
  Scenario: Super Admin successfully deletes a charity   # scenario 'Super Admin successfully deletes a charity' do
    Given I am signed in as a superadmin
    And I visit the show page for the organisation named "Friendly"
    And I click "Delete"
    Then the organisation "Friendly" should be deleted
    And I should see "Deleted Friendly" in the flash
    And I should be on the organisations index page
    And the "2" proposed edits for the organisation named "Friendly" should only be soft deleted

  Scenario: Org superadmin cannot see delete button
    Given I am signed in as a non-superadmin
    And I visit the show page for the organisation named "Friendly"
    And I should not see "Delete"

  Scenario: Non-superadmin cannot see delete button
    Given I am signed in as a non-superadmin
    And I visit the show page for the organisation named "Friendly"
    And I should not see "Delete"

  Scenario: Public cannot see delete button
    Given I visit the show page for the organisation named "Friendly"
    And I should not see "Delete"

  Scenario: Non-superadmin unsuccessfully attempts to delete a charity directly
    Given I am signed in as a non-superadmin
    And I delete "Friendly" charity
    Then I should be on the show page for the organisation named "Friendly"
    And I should see permission denied
